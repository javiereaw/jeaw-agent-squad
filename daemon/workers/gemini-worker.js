/**
 * Gemini Worker - Executes tasks using the Google Gemini API
 */

const fs = require('fs');
const path = require('path');

class GeminiWorker {
  constructor(options = {}) {
    this.apiKeyEnv = options.apiKeyEnv || 'GEMINI_API_KEY';
    this.model = options.model || 'gemini-2.0-flash';
    this.projectPath = options.projectPath || process.cwd();
    this.dryRun = options.dryRun || false;

    // Lazy load SDK
    this.GoogleGenerativeAI = null;
    this.client = null;
    this.genModel = null;
  }

  async initialize() {
    if (this.genModel) return;

    const apiKey = process.env[this.apiKeyEnv];
    if (!apiKey) {
      throw new Error(`API key not found in environment variable: ${this.apiKeyEnv}`);
    }

    try {
      const { GoogleGenerativeAI } = require('@google/generative-ai');
      this.client = new GoogleGenerativeAI(apiKey);
      this.genModel = this.client.getGenerativeModel({ model: this.model });
    } catch (err) {
      throw new Error(`Failed to initialize Gemini SDK: ${err.message}. Run: npm install @google/generative-ai`);
    }
  }

  async execute(prompt) {
    if (this.dryRun) {
      console.log('[DRY-RUN] Gemini worker would execute prompt:');
      console.log(prompt.slice(0, 500) + '...');
      return {
        success: true,
        summary: '[DRY-RUN] Task simulated',
        output: ''
      };
    }

    await this.initialize();

    try {
      const systemPrompt = `You are an AI agent executing a specific task in a software project.
You have access to the project at: ${this.projectPath}

When you need to modify files, output the changes in this format:

<file_change>
<path>relative/path/to/file.js</path>
<action>create|modify|delete</action>
<content>
... file content here ...
</content>
</file_change>

Always be precise and follow the task instructions exactly.
At the end of your response, include either:
- "TASK COMPLETE: <summary>" if successful
- "TASK BLOCKED: <reason>" if you cannot complete the task`;

      const fullPrompt = systemPrompt + '\n\n---\n\n' + prompt;

      const result = await this.genModel.generateContent(fullPrompt);
      const response = await result.response;
      const responseText = response.text();

      // Apply file changes
      await this.applyChanges(responseText);

      // Check for completion status
      const completeMatch = responseText.match(/TASK COMPLETE:\s*(.+?)(?:\n|$)/i);
      const blockedMatch = responseText.match(/TASK BLOCKED:\s*(.+?)(?:\n|$)/i);

      if (blockedMatch) {
        return {
          success: false,
          error: blockedMatch[1].trim(),
          output: responseText
        };
      }

      return {
        success: true,
        summary: completeMatch ? completeMatch[1].trim() : 'Task completed',
        output: responseText
      };

    } catch (err) {
      return {
        success: false,
        error: err.message,
        output: ''
      };
    }
  }

  async applyChanges(responseText) {
    // Parse file changes from response
    const fileChangeRegex = /<file_change>\s*<path>(.+?)<\/path>\s*<action>(.+?)<\/action>\s*<content>([\s\S]*?)<\/content>\s*<\/file_change>/gi;

    let match;
    while ((match = fileChangeRegex.exec(responseText)) !== null) {
      const [, filePath, action, content] = match;
      const fullPath = path.join(this.projectPath, filePath.trim());

      try {
        switch (action.trim().toLowerCase()) {
          case 'create':
          case 'modify':
            // Ensure directory exists
            const dir = path.dirname(fullPath);
            if (!fs.existsSync(dir)) {
              fs.mkdirSync(dir, { recursive: true });
            }
            fs.writeFileSync(fullPath, content.trim());
            console.log(`[Gemini Worker] ${action}: ${filePath}`);
            break;

          case 'delete':
            if (fs.existsSync(fullPath)) {
              fs.unlinkSync(fullPath);
              console.log(`[Gemini Worker] deleted: ${filePath}`);
            }
            break;
        }
      } catch (err) {
        console.error(`[Gemini Worker] Error applying change to ${filePath}: ${err.message}`);
      }
    }
  }
}

module.exports = GeminiWorker;
