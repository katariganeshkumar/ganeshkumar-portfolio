# Ganesh Kumar - Portfolio Website

A modern, WebGL-powered portfolio website showcasing DevOps expertise and technical skills. Built with React, Three.js, and Node.js.

## 🚀 Features

- **3D WebGL Background** - Interactive Three.js background with animated particles
- **Animated SVG Icons** - Dynamic DevOps technology icons with connecting animations
- **Responsive Design** - Fully responsive across all devices
- **Modern UI/UX** - Inspired by best portfolio websites with smooth animations
- **Dynamic Content** - JSON-based content management for easy updates
- **Performance Optimized** - Code splitting and lazy loading for optimal performance

## 🛠️ Tech Stack

### Frontend
- React 18
- Vite
- Three.js / React Three Fiber
- Framer Motion
- GSAP
- React Router

### Backend
- Node.js
- Express
- CORS & Helmet for security

## 📦 Installation

### Prerequisites
- Node.js 18+ 
- npm or yarn

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd Resume3
```

2. Install all dependencies:
```bash
npm run install:all
```

3. Copy the image to public folder:
```bash
cp generated-image.png frontend/public/
```

4. Update profile data:
Edit `backend/data/profile.json` with your information extracted from the PDF.

## 🎯 Development

### Run Development Server

Start both frontend and backend:
```bash
npm run dev
```

Or run separately:
```bash
# Frontend (port 3000)
npm run dev:frontend

# Backend (port 5001)
npm run dev:backend
```

### Build for Production

```bash
npm run build
```

This will build both frontend and backend.

## 🌐 Deployment

### Ubuntu Server Setup

1. **Install Node.js and PM2:**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2
```

2. **Clone and Build:**
```bash
git clone <repository-url>
cd Resume3
npm run install:all
npm run build
```

3. **Configure Nginx:**
```nginx
server {
    listen 80;
    server_name www.ganeshkumar.me ganeshkumar.me;

    location / {
        proxy_pass http://localhost:5001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

4. **Start with PM2:**
```bash
cd backend
pm2 start server.js --name portfolio
pm2 save
pm2 startup
```

5. **SSL with Let's Encrypt:**
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d www.ganeshkumar.me -d ganeshkumar.me
```

## 📝 Content Management

All content is managed through `backend/data/profile.json`. Update this file to change:
- Personal information
- Skills and technologies
- Work experience
- Projects
- Contact information
- Theme colors

## 🎨 Customization

### Colors
Edit CSS variables in `frontend/src/index.css`:
```css
:root {
  --primary: #00D9FF;
  --secondary: #0066FF;
  --accent: #FF6B6B;
  --bg-dark: #0A0E27;
}
```

### 3D Background
Modify `frontend/src/components/Background3D.jsx` to customize the 3D scene.

### Animations
Adjust animation timings in component files using Framer Motion props.

## 📊 Performance

- Code splitting for optimal loading
- Lazy loading of components
- Optimized 3D rendering
- Image optimization
- Compression middleware

## 🔒 Security

- Helmet.js for security headers
- CORS configuration
- Environment variable management
- Input validation

## 📄 License

MIT License

## 👤 Author

**Ganesh Kumar**
- Email: katariganeshkumar@gmail.com
- LinkedIn: [Your LinkedIn]
- GitHub: [Your GitHub]

## 🙏 Acknowledgments

- Three.js community
- React Three Fiber
- Framer Motion
- Lucide Icons

