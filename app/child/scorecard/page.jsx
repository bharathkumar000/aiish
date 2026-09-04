"use client";
import React, { Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Button from '../../../src/components/Button';
import Card from '../../../src/components/Card';
import { Star } from 'lucide-react';

function ScorecardContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  
  const score = parseInt(searchParams.get('score') || '0');
  const total = parseInt(searchParams.get('total') || '3');
  const passed = searchParams.get('passed') === 'true';
  const percentage = (score / total) * 100;

  const moduleId = searchParams.get('moduleId');

  return (
    <div className="animate-fade-in" style={{ 
      backgroundColor: 'var(--color-bg-primary)', 
      minHeight: '100vh', display: 'flex', flexDirection: 'column', 
      alignItems: 'center', justifyContent: 'center', padding: '24px',
      position: 'relative'
    }}>
      
      {/* Home button in the corner */}
      <div style={{ position: 'absolute', top: '24px', left: '24px' }}>
        <button 
          onClick={() => router.push('/child/dashboard')}
          style={{ background: '#FCD5CE', border: '4px solid #4A4036', borderRadius: '50%', width: '48px', height: '48px', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer' }}
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#4A4036" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
            <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
            <polyline points="9 22 9 12 15 12 15 22"/>
          </svg>
        </button>
      </div>

      <h1 style={{ color: '#4A4036', fontSize: '36px', marginBottom: '8px', textAlign: 'center' }}>
        {passed ? 'Level Unlocked!' : 'Challenge Completed!'}
      </h1>
      
      <div style={{ display: 'flex', gap: '8px', marginBottom: '32px' }}>
        {[1, 2, 3].map((star) => (
          <Star 
            key={star} 
            size={48} 
            color={star <= (percentage > 80 ? 3 : percentage > 40 ? 2 : 1) ? '#ffea00' : 'rgba(74, 64, 54, 0.2)'} 
            fill={star <= (percentage > 80 ? 3 : percentage > 40 ? 2 : 1) ? '#ffea00' : 'none'} 
            className="animate-bounce-scale"
          />
        ))}
      </div>

      <Card style={{ width: '100%', maxWidth: '350px', textAlign: 'center', marginBottom: '32px', padding: '32px', border: '5px solid #4A4036', backgroundColor: 'white' }}>
        <p style={{ color: '#4A4036', fontSize: '18px', marginBottom: '8px', fontWeight: 'bold' }}>Your Score</p>
        <h2 style={{ fontSize: '48px', color: '#4A4036', margin: 0 }}>{score} / {total}</h2>
        {!passed && (
          <p style={{ color: 'var(--color-error)', fontWeight: 'bold', marginTop: '16px' }}>Try again to unlock the next level!</p>
        )}
      </Card>

      <div style={{ width: '100%', maxWidth: '350px', display: 'flex', flexDirection: 'column', gap: '16px' }}>
        <Button 
          size="lg" 
          fullWidth 
          onClick={() => router.push(`/child/level/${moduleId || 'phoneme'}`)} 
          style={{ backgroundColor: passed ? 'var(--color-pastel-green)' : 'var(--color-pastel-peach)', color: '#4A4036', border: '5px solid #4A4036' }}
        >
          {passed ? 'Next Level' : 'Try Again'}
        </Button>
      </div>
      
    </div>
  );
}

export default function ChildScorecard() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <ScorecardContent />
    </Suspense>
  )
}
