import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import { readFileSync, existsSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();
const PORT = process.env.PORT || 5001;

// Middleware
app.use(helmet({
  contentSecurityPolicy: false, // Adjust for production
}));
app.use(compression());
app.use(cors());
app.use(express.json());

// API Routes
app.get('/api/profile', (req, res) => {
  try {
    const profileData = JSON.parse(
      readFileSync(join(__dirname, 'data/profile.json'), 'utf8')
    );
    res.json(profileData);
  } catch (error) {
    res.status(500).json({ error: 'Failed to load profile data' });
  }
});

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Serve static files from frontend build (if exists)
const distPath = join(__dirname, '../frontend/dist');
if (existsSync(distPath)) {
  app.use(express.static(distPath));
  
  // Serve React app for all other routes
  app.get('*', (req, res) => {
    res.sendFile(join(distPath, 'index.html'));
  });
} else {
  // Development mode - frontend not built
  app.get('*', (req, res) => {
    res.status(503).json({ 
      error: 'Frontend not built', 
      message: 'Please run "npm run build" or "npm run build:frontend" to build the frontend',
      hint: 'For development, use "npm run dev" instead'
    });
  });
}

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});

