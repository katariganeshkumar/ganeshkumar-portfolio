import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { GraduationCap } from 'lucide-react'
import './Education.css'

const Education = ({ education }) => {
  const [ref, inView] = useInView({ threshold: 0.1 })

  const educationList = education || []

  if (!educationList || educationList.length === 0) {
    return null
  }

  return (
    <section id="education" className="education" ref={ref}>
      <div className="container">
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">Education</span>
          <h2 className="section-title">Academic Background</h2>
        </motion.div>

        <div className="education-timeline">
          {educationList.map((edu, index) => (
            <motion.div
              key={index}
              className="education-item"
              initial={{ opacity: 0, y: 30 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ delay: index * 0.15, duration: 0.6 }}
            >
              <div className="education-icon">
                <GraduationCap size={32} />
              </div>
              <div className="education-content">
                <h3 className="education-degree">{edu.degree}</h3>
                <p className="education-field">{edu.field}</p>
                <p className="education-institution">{edu.institution}</p>
                {edu.year && (
                  <span className="education-year">{edu.year}</span>
                )}
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}

export default Education

