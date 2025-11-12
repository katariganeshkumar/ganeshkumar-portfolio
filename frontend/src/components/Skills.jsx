import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import './Skills.css'

const Skills = ({ skills }) => {
  const [ref, inView] = useInView({ threshold: 0.1 })

  const skillCategories = [
    {
      title: 'Containerization',
      skills: skills?.categories?.containerization || ['Docker', 'Podman', 'Containerd'],
      color: '#00D9FF'
    },
    {
      title: 'Orchestration',
      skills: skills?.categories?.orchestration || ['Kubernetes', 'Docker Swarm'],
      color: '#0066FF'
    },
    {
      title: 'CI/CD',
      skills: skills?.categories?.ci_cd || ['Jenkins', 'GitLab CI', 'GitHub Actions'],
      color: '#FF6B6B'
    },
    {
      title: 'Infrastructure as Code',
      skills: skills?.categories?.iac || ['Terraform', 'Ansible', 'CloudFormation'],
      color: '#00FF88'
    },
    {
      title: 'Cloud Platforms',
      skills: skills?.categories?.cloud || ['AWS', 'Azure', 'GCP'],
      color: '#FFD93D'
    },
    {
      title: 'Monitoring',
      skills: skills?.categories?.monitoring || ['Prometheus', 'Grafana', 'ELK Stack'],
      color: '#9B59B6'
    }
  ]

  return (
    <section id="skills" className="skills" ref={ref}>
      <div className="container">
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">Skills & Technologies</span>
          <h2 className="section-title">Technical Expertise</h2>
        </motion.div>

        <div className="skills-grid">
          {skillCategories.map((category, categoryIndex) => (
            <motion.div
              key={category.title}
              className="skill-category"
              initial={{ opacity: 0, y: 30 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ delay: categoryIndex * 0.1 }}
            >
              <h3 className="category-title" style={{ color: category.color }}>
                {category.title}
              </h3>
              <div className="skills-list">
                {category.skills.map((skill, skillIndex) => (
                  <motion.div
                    key={skill}
                    className="skill-item"
                    initial={{ opacity: 0, scale: 0.8 }}
                    animate={inView ? { opacity: 1, scale: 1 } : {}}
                    transition={{ delay: categoryIndex * 0.1 + skillIndex * 0.05 }}
                    whileHover={{ scale: 1.1, y: -5 }}
                  >
                    <span className="skill-name">{skill}</span>
                    <motion.div
                      className="skill-bar"
                      initial={{ width: 0 }}
                      animate={inView ? { width: `${85 + Math.random() * 15}%` } : {}}
                      transition={{ delay: categoryIndex * 0.1 + skillIndex * 0.05 + 0.3, duration: 1 }}
                      style={{ backgroundColor: category.color }}
                    />
                  </motion.div>
                ))}
              </div>
            </motion.div>
          ))}
        </div>

        {/* Floating tech icons */}
        <div className="floating-icons">
          {skills?.technologies?.slice(0, 12).map((tech, index) => (
            <motion.div
              key={tech}
              className="floating-icon"
              initial={{ opacity: 0, y: 20 }}
              animate={inView ? { 
                opacity: [0.3, 0.6, 0.3],
                y: [0, -20, 0]
              } : {}}
              transition={{
                delay: index * 0.2,
                duration: 3,
                repeat: Infinity,
                ease: "easeInOut"
              }}
            >
              {tech}
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}

export default Skills

