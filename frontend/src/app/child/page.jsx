"use client";
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Header, Button, Card } from '@/components';
import { PlayCircle } from 'lucide-react';

export default function ChildOnboarding() {
  const [name, setName] = useState('');
  const [ageGroup, setAgeGroup] = useState('');
  const router = useRouter();

  const handleStart = () => {
    if (name && ageGroup) {
      // In a real app, we'd save this to context/state
      router.push('/child/dashboard');
    }
  };

  return (
    <div className="p-6 animate-fade-in flex flex-col h-full" style={{ padding: '24px', display: 'flex', flexDirection: 'column', height: '100vh', justifyContent: 'center' }}>
      <div style={{ textAlign: 'center', marginBottom: '32px' }}>
        <h1 style={{ fontSize: '32px', color: 'var(--color-primary-dark)', marginBottom: '8px' }}>Welcome!</h1>
        <p style={{ color: 'var(--color-text-muted)' }}>Parent has to select the child's age range.</p>
      </div>

      <Card className="mb-6" style={{ marginBottom: '24px' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          <div>
            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '8px' }}>Child's Name</label>
            <input 
              type="text" 
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Enter name..."
              style={{ 
                width: '100%', padding: '12px', borderRadius: '8px', 
                border: '2px solid #eee', fontSize: '16px', outline: 'none' 
              }}
            />
          </div>

          <div>
            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '8px' }}>Age Group</label>
            <div style={{ display: 'flex', gap: '12px' }}>
              <Button 
                variant={ageGroup === '7-9' ? 'primary' : 'secondary'} 
                onClick={() => setAgeGroup('7-9')}
                style={{ flex: 1, backgroundColor: ageGroup === '7-9' ? 'var(--color-primary)' : '#eee', color: ageGroup === '7-9' ? '#333' : '#888' }}
              >
                7 - 9.11 Years
              </Button>
              <Button 
                variant={ageGroup === '10-12' ? 'primary' : 'secondary'} 
                onClick={() => setAgeGroup('10-12')}
                style={{ flex: 1, backgroundColor: ageGroup === '10-12' ? 'var(--color-primary)' : '#eee', color: ageGroup === '10-12' ? '#333' : '#888' }}
              >
                10 - 12 Years
              </Button>
            </div>
          </div>
        </div>
      </Card>

      <Button 
        size="lg" 
        fullWidth 
        onClick={handleStart} 
        style={{ 
          opacity: (name && ageGroup) ? 1 : 0.5,
          pointerEvents: (name && ageGroup) ? 'auto' : 'none'
        }}
      >
        Let's Start!
      </Button>
      
      {/* Mascot Placeholder */}
      <div style={{ textAlign: 'center', marginTop: 'auto', paddingTop: '32px' }}>
         <img src="/mascot.png" alt="Mascot" style={{ width: '150px', height: '150px', objectFit: 'contain' }} />
      </div>
    </div>
  );
}
