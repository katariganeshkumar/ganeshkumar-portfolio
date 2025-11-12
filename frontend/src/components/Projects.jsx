import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { ExternalLink, Github } from 'lucide-react'
import './Projects.css'

const Projects = ({ projects }) => {
  const [ref, inView] = useInView({ threshold: 0.1 })

  // Debug logging
  console.log('Projects component received:', projects)

  const projectList = projects && projects.length > 0 ? projects : [
    {
      id: 1,
      name: 'Cloud Infrastructure Automation',
      description: 'Automated cloud infrastructure provisioning and management using Terraform and Ansible',
      technologies: ['Terraform', 'AWS', 'Kubernetes'],
      link: '',
      github: ''
    }
  ]

  console.log('Projects list to render:', projectList)

  return (
    <section id="projects" className="projects" ref={ref}>
      <div className="container">
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">Portfolio Projects</span>
          <h2 className="section-title">Featured Work</h2>
        </motion.div>

        <div className="projects-grid">
          {projectList.map((project, index) => (
            <motion.div
              key={project.id}
              className="project-card"
              initial={{ opacity: 0, y: 50 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ delay: index * 0.1, duration: 0.6 }}
              whileHover={{ y: -10 }}
            >
              <div className="project-header">
                <h3 className="project-title">{project.name}</h3>
                <div className="project-links">
                  {project.github && (
                    <a href={project.github} target="_blank" rel="noopener noreferrer" aria-label="GitHub">
                      <Github size={20} />
                    </a>
                  )}
                  {project.link && (
                    <a href={project.link} target="_blank" rel="noopener noreferrer" aria-label="Live Demo">
                      <ExternalLink size={20} />
                    </a>
                  )}
                </div>
              </div>
              {project.description && (
                <p className="project-description">{project.description}</p>
              )}
              <div className="project-technologies">
                {project.technologies.map((tech) => (
                  <span key={tech} className="tech-badge">
                    {tech}
                  </span>
                ))}
              </div>
              <motion.div
                className="project-overlay"
                initial={{ opacity: 0 }}
                whileHover={{ opacity: 1 }}
              >
                <div className="project-overlay-content">
                  <motion.a
                    href={project.link || project.github || '#'}
                    className="project-button"
                    whileHover={{ scale: 1.05 }}
                    whileTap={{ scale: 0.95 }}
                  >
                    View Project
                  </motion.a>
                </div>
              </motion.div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}

export default Projects

