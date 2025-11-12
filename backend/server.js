import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(helmet({
  contentSecurityPolicy: false, // Adjust for production
}));
app.use(compression());
app.use(cors());
app.use(express.json());

// Serve static files from frontend build
app.use(express.static(join(__dirname, '../frontend/dist')));

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

// Serve React app for all other routes
app.get('*', (req, res) => {
  res.sendFile(join(__dirname, '../frontend/dist/index.html'));
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});

