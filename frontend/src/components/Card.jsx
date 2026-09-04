import React from 'react';
import './components.css';

export default function Card({ children, className = '', onClick, style }) {
  return (
    <div className={`card ${onClick ? 'clickable animate-bounce-scale' : ''} ${className}`} onClick={onClick} style={style}>
      {children}
    </div>
  );
}
