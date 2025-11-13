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
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'", "https://fonts.googleapis.com"],
      styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com"],
      fontSrc: ["'self'", "https://fonts.gstatic.com"],
      imgSrc: ["'self'", "data:", "blob:", "https://raw.githack.com", "https://raw.githubusercontent.com"],
      connectSrc: ["'self'", "https://raw.githack.com", "https://raw.githubusercontent.com", "https://cdn.jsdelivr.net", "https://unpkg.com"],
    },
  },
  crossOriginEmbedderPolicy: false,
}));
app.use(compression());
app.use(cors());
app.use(express.json());

// Cache for profile data
let profileCache = null;
let profileCacheTime = null;
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutes

// API Routes
app.get('/api/profile', (req, res) => {
  try {
    const now = Date.now();
    
    // Return cached data if still valid
    if (profileCache && profileCacheTime && (now - profileCacheTime) < CACHE_DURATION) {
      res.set({
        'Cache-Control': 'public, max-age=300',
        'ETag': `"${profileCacheTime}"`,
      });
      return res.json(profileCache);
    }
    
    // Load fresh data
    const profileData = JSON.parse(
      readFileSync(join(__dirname, 'data/profile.json'), 'utf8')
    );
    
    // Update cache
    profileCache = profileData;
    profileCacheTime = now;
    
    res.set({
      'Cache-Control': 'public, max-age=300',
      'ETag': `"${now}"`,
    });
    res.json(profileData);
  } catch (error) {
    console.error('Error loading profile:', error);
    res.status(500).json({ error: 'Failed to load profile data' });
  }
});

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Contact form endpoint
app.post('/api/contact', (req, res) => {
  try {
    const { name, email, message } = req.body;
    
    // Basic validation
    if (!name || !email || !message) {
      return res.status(400).json({ error: 'All fields are required' });
    }
    
    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: 'Invalid email address' });
    }
    
    // Log the contact form submission (in production, send email here)
    console.log('Contact form submission:', { name, email, message, timestamp: new Date().toISOString() });
    
    // TODO: Integrate with email service (SendGrid, Nodemailer, etc.)
    // For now, return success
    res.json({ 
      success: true, 
      message: 'Thank you for your message! I will get back to you soon.' 
    });
  } catch (error) {
    console.error('Error processing contact form:', error);
    res.status(500).json({ error: 'Failed to send message. Please try again later.' });
  }
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

