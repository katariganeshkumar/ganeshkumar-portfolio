import { useState } from 'react'
import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { Mail, Linkedin, Github, Send } from 'lucide-react'
import './Contact.css'

const Contact = ({ profile }) => {
  const [ref, inView] = useInView({ threshold: 0.1 })
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    message: ''
  })
  const [submitted, setSubmitted] = useState(false)
  const [error, setError] = useState('')

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    
    try {
      const response = await fetch('/api/contact', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      })
      
      const data = await response.json()
      
      if (response.ok) {
        setSubmitted(true)
        setTimeout(() => {
          setSubmitted(false)
          setFormData({ name: '', email: '', message: '' })
        }, 3000)
      } else {
        setError(data.error || 'Failed to send message. Please try again.')
      }
    } catch (error) {
      console.error('Error sending message:', error)
      setError('Network error. Please check your connection and try again.')
    }
  }

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  return (
    <section id="contact" className="contact" ref={ref}>
      <div className="container">
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">Get In Touch</span>
          <h2 className="section-title">Let's Work Together</h2>
          <p className="section-subtitle">
            I'm always open to discussing new opportunities and interesting projects.
          </p>
        </motion.div>

        <div className="contact-content">
          <motion.div
            className="contact-info"
            initial={{ opacity: 0, x: -50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ delay: 0.2, duration: 0.6 }}
          >
            <h3>Contact Information</h3>
            <div className="contact-items">
              {profile?.email && (
                <a href={`mailto:${profile.email}`} className="contact-item">
                  <Mail size={24} />
                  <div>
                    <span className="contact-label">Email</span>
                    <span className="contact-value">{profile.email}</span>
                  </div>
                </a>
              )}
              {profile?.social?.linkedin && (
                <a href={profile.social.linkedin} target="_blank" rel="noopener noreferrer" className="contact-item">
                  <Linkedin size={24} />
                  <div>
                    <span className="contact-label">LinkedIn</span>
                    <span className="contact-value">Connect with me</span>
                  </div>
                </a>
              )}
              {profile?.social?.github && (
                <a href={profile.social.github} target="_blank" rel="noopener noreferrer" className="contact-item">
                  <Github size={24} />
                  <div>
                    <span className="contact-label">GitHub</span>
                    <span className="contact-value">View my code</span>
                  </div>
                </a>
              )}
            </div>
          </motion.div>

          <motion.form
            className="contact-form"
            onSubmit={handleSubmit}
            initial={{ opacity: 0, x: 50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ delay: 0.4, duration: 0.6 }}
          >
            <div className="form-group">
              <input
                type="text"
                name="name"
                placeholder="Your Name"
                value={formData.name}
                onChange={handleChange}
                required
                className="form-input"
              />
            </div>
            <div className="form-group">
              <input
                type="email"
                name="email"
                placeholder="Your Email"
                value={formData.email}
                onChange={handleChange}
                required
                className="form-input"
              />
            </div>
            <div className="form-group">
              <textarea
                name="message"
                placeholder="Your Message"
                value={formData.message}
                onChange={handleChange}
                required
                rows="6"
                className="form-textarea"
              />
            </div>
            {error && (
              <div className="form-error">
                {error}
              </div>
            )}
            <motion.button
              type="submit"
              className="form-submit"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              disabled={submitted}
            >
              <Send size={20} />
              {submitted ? 'Message Sent!' : 'Send Message'}
            </motion.button>
          </motion.form>
        </div>
      </div>

      <motion.footer
        className="footer"
        initial={{ opacity: 0 }}
        animate={inView ? { opacity: 1 } : {}}
        transition={{ delay: 0.6 }}
      >
        <div className="container">
          <p>&copy; {new Date().getFullYear()} Ganesh Kumar. All rights reserved.</p>
          <p className="footer-note">Built with ReactJS, Three.js, and ExpressJS</p>
        </div>
      </motion.footer>
    </section>
  )
}

export default Contact

