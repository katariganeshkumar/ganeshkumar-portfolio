import { useEffect, useState } from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { Canvas } from '@react-three/fiber'
import { OrbitControls, PerspectiveCamera, Environment } from '@react-three/drei'
import Header from './components/Header'
import Hero from './components/Hero'
import About from './components/About'
import Skills from './components/Skills'
import Experience from './components/Experience'
import Projects from './components/Projects'
import Education from './components/Education'
import Contact from './components/Contact'
import Background3D from './components/Background3D'
import LoadingScreen from './components/LoadingScreen'
import './App.css'

function App() {
  const [profileData, setProfileData] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetch('/api/profile')
      .then(res => res.json())
      .then(data => {
        console.log('Profile data loaded:', data)
        console.log('Education data:', data?.education)
        console.log('Projects data:', data?.projects)
        setProfileData(data)
        setTimeout(() => setLoading(false), 1500)
      })
      .catch(err => {
        console.error('Failed to load profile:', err)
        setLoading(false)
      })
  }, [])

  if (loading) {
    return <LoadingScreen />
  }

  return (
    <Router>
      <div className="app">
        <div className="canvas-container">
          <Canvas>
            <PerspectiveCamera makeDefault position={[0, 0, 5]} />
            <OrbitControls enableZoom={false} enablePan={false} autoRotate autoRotateSpeed={0.5} />
            <ambientLight intensity={0.5} />
            <pointLight position={[10, 10, 10]} />
            <Environment preset="night" />
            <Background3D />
          </Canvas>
        </div>
        
        <div className="content-wrapper">
          <Header />
          <Routes>
            <Route path="/" element={
              <>
                <Hero profile={profileData?.personal} />
                <About profile={profileData} />
                <Skills skills={profileData?.skills} />
                <Experience experience={profileData?.experience} />
                {profileData?.projects && <Projects projects={profileData.projects} />}
                {profileData?.education && <Education education={profileData.education} />}
                <Contact profile={profileData?.personal} />
              </>
            } />
          </Routes>
        </div>
      </div>
    </Router>
  )
}

export default App

