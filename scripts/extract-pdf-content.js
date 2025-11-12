/**
 * PDF Content Extraction Utility
 * 
 * This script helps extract content from Ganeshkumar.pdf
 * Note: Requires pdf-parse package: npm install pdf-parse
 * 
 * Usage: node scripts/extract-pdf-content.js
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Try to use pdf-parse if available
let pdfParse;
try {
  pdfParse = (await import('pdf-parse')).default;
} catch (e) {
  console.log('pdf-parse not installed. Install with: npm install pdf-parse');
  console.log('For now, manually update backend/data/profile.json with your resume information.');
  process.exit(0);
}

async function extractPDFContent() {
  try {
    const pdfPath = path.join(__dirname, '../Ganeshkumar.pdf');
    const dataBuffer = fs.readFileSync(pdfPath);
    const data = await pdfParse(dataBuffer);
    
    console.log('=== PDF Content Extracted ===\n');
    console.log('Number of pages:', data.numpages);
    console.log('\n=== Text Content ===\n');
    console.log(data.text);
    
    // Save to file
    const outputPath = path.join(__dirname, '../extracted-content.txt');
    fs.writeFileSync(outputPath, data.text);
    console.log(`\n✅ Content saved to: ${outputPath}`);
    console.log('\n📝 Next steps:');
    console.log('1. Review extracted-content.txt');
    console.log('2. Update backend/data/profile.json with your information');
    console.log('3. Fill in experience, projects, education sections');
    
  } catch (error) {
    console.error('Error extracting PDF:', error.message);
    console.log('\nAlternative: Manually review Ganeshkumar.pdf and update backend/data/profile.json');
  }
}

extractPDFContent();

