# Quick Start Guide

Get your portfolio website up and running in minutes!

## 🚀 Local Development

### Troubleshooting Port Issues

If you encounter `EADDRINUSE: address already in use :::5000` error:

**Quick Fix:**
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9

# Or use a different port
PORT=5001 npm start
```

### 1. Install Dependencies
```bash
npm run install:all
```

### 2. Copy Your Image
```bash
cp generated-image.png frontend/public/
```

### 3. Update Your Profile
Edit `backend/data/profile.json` with your information:
- Personal details (name, email, bio)
- Skills and technologies
- Work experience
- Projects
- Contact information

### 4. Start Development Server
```bash
npm run dev
```

This starts:
- Frontend on http://localhost:3000
- Backend API on http://localhost:5000

## 📝 Content Management

All content is managed through `backend/data/profile.json`. 

### Example Structure:
```json
{
  "personal": {
    "name": "Your Name",
    "title": "Your Title",
    "email": "your@email.com",
    "bio": "Your bio here"
  },
  "skills": {
    "technologies": ["Docker", "Kubernetes", "AWS"],
    "categories": {
      "containerization": ["Docker", "Podman"],
      "orchestration": ["Kubernetes"]
    }
  },
  "experience": [
    {
      "title": "Your Role",
      "company": "Company Name",
      "period": "2020 - Present",
      "description": "Job description",
      "achievements": ["Achievement 1", "Achievement 2"],
      "technologies": ["Tech 1", "Tech 2"]
    }
  ],
  "projects": [
    {
      "name": "Project Name",
      "description": "Project description",
      "technologies": ["Tech 1", "Tech 2"],
      "link": "https://project-url.com",
      "github": "https://github.com/user/repo"
    }
  ]
}
```

## 🎨 Customization

### Colors
Edit `frontend/src/index.css`:
```css
:root {
  --primary: #00D9FF;      /* Primary accent color */
  --secondary: #0066FF;    /* Secondary color */
  --accent: #FF6B6B;       /* Accent color */
  --bg-dark: #0A0E27;      /* Background */
}
```

### 3D Background
Modify `frontend/src/components/Background3D.jsx` to customize the WebGL scene.

### Animations
Adjust animation timings in component files using Framer Motion.

## 🏗️ Build for Production

```bash
npm run build
```

Output:
- Frontend: `frontend/dist/`
- Backend: Ready to run with `npm start`

## 🌐 Deploy to Server

See `DEPLOYMENT.md` for complete deployment instructions.

Quick deploy:
```bash
bash deploy.sh
```

## 📦 Project Structure

```
.
├── frontend/          # React frontend
│   ├── src/
│   │   ├── components/  # React components
│   │   ├── App.jsx      # Main app
│   │   └── main.jsx     # Entry point
│   └── public/         # Static assets
├── backend/           # Node.js backend
│   ├── data/
│   │   └── profile.json # Content data
│   └── server.js       # Express server
├── scripts/           # Utility scripts
└── deploy.sh          # Deployment script
```

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Kill process on port 3000 or 5000
lsof -ti:3000 | xargs kill -9
lsof -ti:5000 | xargs kill -9
```

### Dependencies Issues
```bash
# Clean install
rm -rf node_modules frontend/node_modules backend/node_modules
npm run install:all
```

### Build Errors
```bash
# Clear cache and rebuild
rm -rf frontend/dist frontend/.vite
npm run build
```

## 📚 Next Steps

1. ✅ Update `backend/data/profile.json` with your information
2. ✅ Customize colors and styling
3. ✅ Add your projects and experience
4. ✅ Test locally
5. ✅ Deploy to your server

## 💡 Tips

- Use the PDF extraction script: `npm run extract-pdf` (requires pdf-parse)
- Check browser console for errors
- Use React DevTools for debugging
- Monitor performance with browser DevTools

## 🆘 Need Help?

- Check `README.md` for detailed documentation
- Review `DEPLOYMENT.md` for server setup
- Check component files for customization options

