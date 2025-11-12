import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { Code, Server, Cloud, Zap } from 'lucide-react'
import './About.css'

const About = ({ profile }) => {
  const [ref, inView] = useInView({ threshold: 0.2 })

  const features = [
    {
      icon: <Cloud size={32} />,
      title: 'Cloud Infrastructure',
      description: 'Design and deploy scalable cloud solutions'
    },
    {
      icon: <Server size={32} />,
      title: 'Container Orchestration',
      description: 'Expert in Kubernetes and Docker ecosystems'
    },
    {
      icon: <Zap size={32} />,
      title: 'CI/CD Automation',
      description: 'Build efficient deployment pipelines'
    },
    {
      icon: <Code size={32} />,
      title: 'Infrastructure as Code',
      description: 'Automate infrastructure with Terraform & Ansible'
    }
  ]

  return (
    <section id="about" className="about" ref={ref}>
      <div className="container">
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">About Me</span>
          <h2 className="section-title">DevOps Engineer & Cloud Architect</h2>
        </motion.div>

        <div className="about-content">
          <motion.div
            className="about-text"
            initial={{ opacity: 0, x: -50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.6, delay: 0.2 }}
          >
            <p className="about-description">
              {profile?.personal?.bio || 'Experienced Senior DevOps Engineer with a passion for building scalable, reliable, and efficient infrastructure solutions.'}
            </p>
            <p className="about-description">
              I specialize in containerization, orchestration, and cloud infrastructure automation. 
              My expertise includes designing CI/CD pipelines, managing Kubernetes clusters, and implementing 
              Infrastructure as Code practices to streamline development workflows.
            </p>
            <div className="about-stats">
              <div className="stat-item">
                <span className="stat-number">5+</span>
                <span className="stat-label">Years Experience</span>
              </div>
              <div className="stat-item">
                <span className="stat-number">50+</span>
                <span className="stat-label">Projects Completed</span>
              </div>
              <div className="stat-item">
                <span className="stat-number">100%</span>
                <span className="stat-label">Automation Focus</span>
              </div>
            </div>
          </motion.div>

          <motion.div
            className="about-features"
            initial={{ opacity: 0, x: 50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.6, delay: 0.4 }}
          >
            {features.map((feature, index) => (
              <motion.div
                key={feature.title}
                className="feature-card"
                initial={{ opacity: 0, y: 30 }}
                animate={inView ? { opacity: 1, y: 0 } : {}}
                transition={{ delay: 0.6 + index * 0.1 }}
                whileHover={{ y: -5 }}
              >
                <div className="feature-icon">{feature.icon}</div>
                <h3 className="feature-title">{feature.title}</h3>
                <p className="feature-description">{feature.description}</p>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </div>
    </section>
  )
}

export default About

