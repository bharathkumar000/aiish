"use client";
import React from 'react';
import { useRouter } from 'next/navigation';
import { Button, Card } from '@/components';
import { Castle, Star } from 'lucide-react';

export default function VictoryScreen() {
  const router = useRouter();

  return (
    <div className="animate-fade-in" style={{ 
      backgroundColor: '#FFD700', 
      minHeight: '100vh', display: 'flex', flexDirection: 'column', 
      alignItems: 'center', justifyContent: 'center', padding: '24px',
      overflow: 'hidden', position: 'relative'
    }}>
      
      {/* Confetti / Stars simulation */}
      <div className="animate-pulse" style={{ position: 'absolute', top: 50, left: 50 }}><Star fill="white" color="white" size={40} /></div>
      <div className="animate-pulse" style={{ position: 'absolute', top: 80, right: 60 }}><Star fill="white" color="white" size={30} /></div>
      <div className="animate-bounce-scale" style={{ position: 'absolute', bottom: 120, left: 80 }}><Star fill="white" color="white" size={50} /></div>
      <div className="animate-pulse" style={{ position: 'absolute', bottom: 150, right: 40 }}><Star fill="white" color="white" size={35} /></div>

      <div className="animate-bounce-scale" style={{
        backgroundColor: 'white', width: '150px', height: '150px', borderRadius: '50%',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        border: '6px solid #4A4036', boxShadow: '0px 10px 0px #4A4036',
        marginBottom: '24px', zIndex: 10
      }}>
        <Castle size={80} color="#4A4036" strokeWidth={2} />
      </div>

      <h1 style={{ 
        color: '#4A4036', fontSize: '48px', marginBottom: '8px', 
        textAlign: 'center', textShadow: '2px 2px 0px white',
        fontWeight: '900', zIndex: 10
      }}>
        YOU WIN!
      </h1>
      
      <p style={{ color: '#4A4036', fontSize: '20px', fontWeight: 'bold', marginBottom: '40px', textAlign: 'center', zIndex: 10 }}>
        You reached the castle and completed all the games!
      </p>

      <div style={{ width: '100%', zIndex: 10, display: 'flex', flexDirection: 'column', gap: '16px' }}>
        <Button size="lg" fullWidth onClick={() => router.push('/child/dashboard')} style={{ backgroundColor: 'white', color: '#4A4036' }}>
          Back to Map
        </Button>
      </div>
      
    </div>
  );
}
