import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import './TechIcons.css'

const TechIcons = () => {
  const [ref, inView] = useInView({ threshold: 0.1 })

  const icons = [
    { name: 'Docker', icon: '🐳', position: { top: '10%', left: '20%' } },
    { name: 'Kubernetes', icon: '☸️', position: { top: '30%', right: '15%' } },
    { name: 'Git', icon: '📦', position: { bottom: '30%', left: '10%' } },
    { name: 'AWS', icon: '☁️', position: { top: '50%', left: '5%' } },
    { name: 'Jenkins', icon: '🔧', position: { bottom: '20%', right: '20%' } },
    { name: 'Terraform', icon: '🏗️', position: { top: '20%', left: '50%' } },
    { name: 'Linux', icon: '🐧', position: { bottom: '40%', right: '5%' } },
    { name: 'CI/CD', icon: '⚡', position: { top: '60%', right: '30%' } }
  ]

  return (
    <div className="tech-icons-container" ref={ref}>
      {icons.map((item, index) => (
        <motion.div
          key={item.name}
          className="tech-icon"
          style={item.position}
          initial={{ opacity: 0, scale: 0 }}
          animate={inView ? { opacity: 1, scale: 1 } : {}}
          transition={{
            delay: index * 0.1,
            type: 'spring',
            stiffness: 100
          }}
          whileHover={{ scale: 1.2, rotate: 10 }}
        >
          <div className="icon-emoji">{item.icon}</div>
          <div className="icon-label">{item.name}</div>
          <motion.div
            className="icon-connection"
            initial={{ scaleX: 0 }}
            animate={inView ? { scaleX: 1 } : {}}
            transition={{ delay: index * 0.1 + 0.5 }}
          />
        </motion.div>
      ))}
      
      {/* Animated connecting lines */}
      <svg className="connections-svg" viewBox="0 0 500 500">
        <motion.path
          d="M100,50 Q250,150 400,100"
          stroke="url(#gradient)"
          strokeWidth="2"
          fill="none"
          initial={{ pathLength: 0 }}
          animate={inView ? { pathLength: 1 } : {}}
          transition={{ duration: 2, delay: 0.5 }}
        />
        <motion.path
          d="M50,200 Q150,100 250,250"
          stroke="url(#gradient)"
          strokeWidth="2"
          fill="none"
          initial={{ pathLength: 0 }}
          animate={inView ? { pathLength: 1 } : {}}
          transition={{ duration: 2, delay: 0.7 }}
        />
        <defs>
          <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor="#00D9FF" stopOpacity="0.5" />
            <stop offset="100%" stopColor="#0066FF" stopOpacity="0.5" />
          </linearGradient>
        </defs>
      </svg>
    </div>
  )
}

export default TechIcons

