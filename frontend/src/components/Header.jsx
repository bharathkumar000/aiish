"use client";
import React from 'react';
import { useRouter } from 'next/navigation';
import { ArrowLeft } from 'lucide-react';
import './components.css';

export default function Header({ title, showBack = false, onBack }) {
  const router = useRouter();
  
  const handleBack = () => {
    if (onBack) onBack();
    else router.back();
  };

  return (
    <div className="header-container" style={{ position: 'relative', zIndex: 100 }}>
      {showBack ? (
        <button onClick={handleBack} className="btn btn-primary" style={{ padding: '8px', borderRadius: '50%' }}>
          <ArrowLeft size={24} />
        </button>
      ) : <div style={{ width: 40 }} />}
      
      <h2 style={{ margin: 0, fontSize: '20px', fontWeight: '800' }}>{title}</h2>
      
      <div style={{ width: 40 }}>
        {/* Placeholder for settings or profile icon */}
      </div>
    </div>
  );
}
