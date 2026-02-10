const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const CWD = process.cwd();
const TEMPLATES_DIR = path.join(CWD, 'templates');
const DATA_DIR = path.join(CWD, 'data');
const OUTPUT_DIR = path.join(CWD, 'public');

function findTemplates(dir, fileList = []) {
  const files = fs.readdirSync(dir);
  
  files.forEach(file => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    
    if (stat.isDirectory()) {
      findTemplates(filePath, fileList);
    } else if (path.extname(file) === '.rkt') {
      fileList.push(filePath);
    }
  });
  
  return fileList;
}

function renderTemplate(templatePath) {
  const relativePath = path.relative(TEMPLATES_DIR, templatePath);
  const templateName = path.basename(relativePath, '.rkt');
  const templateDir = path.dirname(relativePath);
  
  const dataFileName = templateName + '.rktd';
  const dataPath = path.join(DATA_DIR, templateDir, dataFileName);
  
  const dataArg = fs.existsSync(dataPath) ? dataPath : path.join(CWD, 'empty.rktd');
  
  console.log(`Rendering: ${relativePath}`);
  console.log(`  Template: ${templatePath}`);
  console.log(`  Data: ${dataArg}`);
  
  const html = execSync(`racket render.rkt "${templatePath}" "${dataArg}"`).toString();
  
  const outputPath = path.join(OUTPUT_DIR, templateDir, templateName + '.html');
  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, html);
  
  console.log(`  Output: ${outputPath}\n`);
  
  return outputPath;
}

function buildAll() {
  console.log('Finding templates...\n');
  const templates = findTemplates(TEMPLATES_DIR);
  
  console.log(`Found ${templates.length} template(s)\n`);
  
  templates.forEach(templatePath => {
    try {
      renderTemplate(templatePath);
    } catch (error) {
      console.error(`Error rendering ${templatePath}:`, error.message);
    }
  });
  
  console.log('Build complete!');
}

buildAll();