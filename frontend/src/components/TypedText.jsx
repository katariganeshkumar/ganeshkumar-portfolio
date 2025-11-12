import { useState, useEffect } from 'react'

const TypedText = ({ strings, typeSpeed = 50, backSpeed = 30, loop = true }) => {
  const [currentStringIndex, setCurrentStringIndex] = useState(0)
  const [currentText, setCurrentText] = useState('')
  const [isDeleting, setIsDeleting] = useState(false)

  useEffect(() => {
    const currentString = strings[currentStringIndex]
    let timeout

    if (!isDeleting && currentText.length < currentString.length) {
      // Typing
      timeout = setTimeout(() => {
        setCurrentText(currentString.slice(0, currentText.length + 1))
      }, typeSpeed)
    } else if (!isDeleting && currentText.length === currentString.length) {
      // Pause before deleting
      timeout = setTimeout(() => {
        setIsDeleting(true)
      }, 2000)
    } else if (isDeleting && currentText.length > 0) {
      // Deleting
      timeout = setTimeout(() => {
        setCurrentText(currentString.slice(0, currentText.length - 1))
      }, backSpeed)
    } else if (isDeleting && currentText.length === 0) {
      // Move to next string
      setIsDeleting(false)
      if (loop) {
        setCurrentStringIndex((prev) => (prev + 1) % strings.length)
      } else if (currentStringIndex < strings.length - 1) {
        setCurrentStringIndex((prev) => prev + 1)
      }
    }

    return () => clearTimeout(timeout)
  }, [currentText, isDeleting, currentStringIndex, strings, typeSpeed, backSpeed, loop])

  return <span>{currentText}</span>
}

export default TypedText

