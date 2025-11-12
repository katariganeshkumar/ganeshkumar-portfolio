import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { Calendar, MapPin, Briefcase } from 'lucide-react'
import './Experience.css'

const Experience = ({ experience }) => {
  const [ref, inView] = useInView({ threshold: 0.1 })

  const experiences = experience || [
    {
      id: 1,
      title: 'Senior DevOps Engineer',
      company: 'Persistent Systems',
      location: 'India',
      period: '2020 - Present',
      description: 'Leading DevOps initiatives and infrastructure automation projects.',
      achievements: [
        'Designed and implemented CI/CD pipelines reducing deployment time by 60%',
        'Managed Kubernetes clusters serving production workloads',
        'Automated infrastructure provisioning using Terraform and Ansible'
      ],
      technologies: ['Kubernetes', 'Docker', 'Jenkins', 'Terraform', 'AWS']
    }
  ]

  return (
    <section id="experience" className="experience" ref={ref}>
      <div className="container">
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">Work Experience</span>
          <h2 className="section-title">Professional Journey</h2>
        </motion.div>

        <div className="timeline">
          {experiences.map((exp, index) => (
            <motion.div
              key={exp.id}
              className="timeline-item"
              initial={{ opacity: 0, x: index % 2 === 0 ? -50 : 50 }}
              animate={inView ? { opacity: 1, x: 0 } : {}}
              transition={{ delay: index * 0.2, duration: 0.6 }}
            >
              <div className="timeline-marker" />
              <div className="timeline-content">
                <div className="experience-header">
                  <div>
                    <h3 className="experience-title">{exp.title}</h3>
                    <div className="experience-meta">
                      <span className="experience-company">
                        <Briefcase size={16} />
                        {exp.company}
                      </span>
                      <span className="experience-location">
                        <MapPin size={16} />
                        {exp.location}
                      </span>
                      <span className="experience-period">
                        <Calendar size={16} />
                        {exp.period}
                      </span>
                    </div>
                  </div>
                </div>
                <p className="experience-description">{exp.description}</p>
                {exp.achievements && exp.achievements.length > 0 && (
                  <ul className="achievements-list">
                    {exp.achievements.map((achievement, idx) => (
                      <motion.li
                        key={idx}
                        initial={{ opacity: 0, x: -20 }}
                        animate={inView ? { opacity: 1, x: 0 } : {}}
                        transition={{ delay: index * 0.2 + idx * 0.1 }}
                      >
                        {achievement}
                      </motion.li>
                    ))}
                  </ul>
                )}
                {exp.technologies && exp.technologies.length > 0 && (
                  <div className="technologies-tags">
                    {exp.technologies.map((tech) => (
                      <span key={tech} className="tech-tag">
                        {tech}
                      </span>
                    ))}
                  </div>
                )}
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}

export default Experience

