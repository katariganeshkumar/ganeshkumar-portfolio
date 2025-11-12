import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import { MeshDistortMaterial, Sphere } from '@react-three/drei'
import * as THREE from 'three'

const Background3D = () => {
  const meshRef = useRef()
  const particlesRef = useRef()

  useFrame((state) => {
    if (meshRef.current) {
      meshRef.current.rotation.x = Math.sin(state.clock.elapsedTime) * 0.1
      meshRef.current.rotation.y = Math.sin(state.clock.elapsedTime * 0.5) * 0.1
    }
  })

  const particles = Array.from({ length: 50 }, (_, i) => ({
    position: [
      (Math.random() - 0.5) * 20,
      (Math.random() - 0.5) * 20,
      (Math.random() - 0.5) * 20
    ],
    scale: Math.random() * 0.5 + 0.1
  }))

  return (
    <>
      {/* Main animated sphere */}
      <Sphere ref={meshRef} args={[1, 32, 32]} position={[0, 0, -5]}>
        <MeshDistortMaterial
          color="#00D9FF"
          attach="material"
          distort={0.3}
          speed={2}
          transparent
          opacity={0.1}
        />
      </Sphere>

      {/* Floating particles */}
      {particles.map((particle, i) => (
        <Sphere
          key={i}
          args={[particle.scale, 16, 16]}
          position={particle.position}
        >
          <meshStandardMaterial
            color="#0066FF"
            transparent
            opacity={0.3}
            emissive="#00D9FF"
            emissiveIntensity={0.2}
          />
        </Sphere>
      ))}
    </>
  )
}

export default Background3D

