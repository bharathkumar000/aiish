import React from 'react';
import './components.css'; // Let's put basic component styles here

export default function Button({ children, variant = 'primary', size = 'md', onClick, fullWidth, className = '' }) {
  const baseClass = `btn btn-${variant} btn-${size} ${fullWidth ? 'btn-full' : ''} ${className} animate-bounce-scale`;
  return (
    <button className={baseClass} onClick={onClick}>
      {children}
    </button>
  );
}
