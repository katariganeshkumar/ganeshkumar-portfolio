import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { ArrowDown, Github, Linkedin, Mail, Download } from 'lucide-react'
import TechIcons from './TechIcons'
import TypedText from './TypedText'
import './Hero.css'

const Hero = ({ profile }) => {
  const [ref, inView] = useInView({ threshold: 0.1 })

  const scrollToAbout = () => {
    document.querySelector('#about')?.scrollIntoView({ behavior: 'smooth' })
  }

  return (
    <section id="home" className="hero" ref={ref}>
      <div className="hero-container">
        <motion.div
          className="hero-content"
          initial={{ opacity: 0, y: 50 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
        >
          <motion.div
            className="hero-badge"
            initial={{ opacity: 0, scale: 0.8 }}
            animate={inView ? { opacity: 1, scale: 1 } : {}}
            transition={{ delay: 0.2 }}
          >
            <span>{profile?.title || 'Senior DevOps Engineer'}</span>
          </motion.div>

          <h1 className="hero-title">
            <span className="hero-name">{profile?.name || 'Ganesh Kumar'}</span>
            <br />
            <span className="hero-subtitle">
              I build{' '}
              <span className="typed-text">
                <TypedText
                  strings={[
                    'Scalable Infrastructure',
                    'CI/CD Pipelines',
                    'Cloud Solutions',
                    'DevOps Automation'
                  ]}
                  typeSpeed={50}
                  backSpeed={30}
                  loop
                />
              </span>
            </span>
          </h1>

          <motion.p
            className="hero-description"
            initial={{ opacity: 0 }}
            animate={inView ? { opacity: 1 } : {}}
            transition={{ delay: 0.4 }}
          >
            {profile?.bio || 'Experienced DevOps Engineer passionate about automation, cloud infrastructure, and scalable systems.'}
          </motion.p>

          <motion.div
            className="hero-actions"
            initial={{ opacity: 0, y: 20 }}
            animate={inView ? { opacity: 1, y: 0 } : {}}
            transition={{ delay: 0.6 }}
          >
            <motion.a
              href="#contact"
              className="btn btn-primary"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              Get In Touch
            </motion.a>
            <motion.a
              href="#projects"
              className="btn btn-secondary"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              View Projects
            </motion.a>
            <motion.a
              href="/resume.pdf"
              download
              className="btn btn-outline"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={(e) => {
                // If resume.pdf doesn't exist, prevent download and show message
                e.preventDefault()
                alert('Resume download will be available soon. Please contact me directly for my resume.')
              }}
            >
              <Download size={18} />
              Resume
            </motion.a>
          </motion.div>

          <motion.div
            className="hero-social"
            initial={{ opacity: 0 }}
            animate={inView ? { opacity: 1 } : {}}
            transition={{ delay: 0.8 }}
          >
            {profile?.social?.github && (
              <a href={profile.social.github} target="_blank" rel="noopener noreferrer" aria-label="GitHub">
                <Github size={20} />
              </a>
            )}
            {profile?.social?.linkedin && (
              <a href={profile.social.linkedin} target="_blank" rel="noopener noreferrer" aria-label="LinkedIn">
                <Linkedin size={20} />
              </a>
            )}
            {profile?.email && (
              <a href={`mailto:${profile.email}`} aria-label="Email">
                <Mail size={20} />
              </a>
            )}
          </motion.div>
        </motion.div>

        <motion.div
          className="hero-visual"
          initial={{ opacity: 0, scale: 0.8 }}
          animate={inView ? { opacity: 1, scale: 1 } : {}}
          transition={{ delay: 0.3, duration: 0.8 }}
        >
          <TechIcons />
        </motion.div>
      </div>

      <motion.button
        className="scroll-indicator"
        onClick={scrollToAbout}
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1 }}
        whileHover={{ y: 5 }}
      >
        <ArrowDown size={24} />
        <span>Scroll</span>
      </motion.button>
    </section>
  )
}

export default Hero

