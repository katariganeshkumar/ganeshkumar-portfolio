import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { Award, ExternalLink } from 'lucide-react'
import './Certifications.css'

const Certifications = ({ certifications }) => {
  const [ref, inView] = useInView({ threshold: 0.1 })

  if (!certifications || certifications.length === 0) {
    return null
  }

  return (
    <section id="certifications" className="certifications" ref={ref}>
      <div className="container">
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">Certifications</span>
          <h2 className="section-title">Professional Certifications</h2>
        </motion.div>

        <div className="certifications-grid">
          {certifications.map((cert, index) => (
            <motion.div
              key={cert.id || index}
              className="certification-card"
              initial={{ opacity: 0, y: 30 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ delay: index * 0.1, duration: 0.6 }}
              whileHover={{ y: -5 }}
            >
              <div className="certification-icon">
                <Award size={32} />
              </div>
              <div className="certification-content">
                <h3 className="certification-name">{cert.name}</h3>
                {cert.issuer && (
                  <p className="certification-issuer">{cert.issuer}</p>
                )}
                {cert.date && (
                  <span className="certification-date">{cert.date}</span>
                )}
                {cert.credentialId && (
                  <span className="certification-id">ID: {cert.credentialId}</span>
                )}
                {cert.url && (
                  <a
                    href={cert.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="certification-link"
                  >
                    <ExternalLink size={16} />
                    Verify Credential
                  </a>
                )}
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}

export default Certifications

