"use client";
import React, { Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Button from '../../../../src/components/Button';
import Card from '../../../../src/components/Card';
import { Star } from 'lucide-react';

function ScorecardContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  
  const score = parseInt(searchParams.get('score') || '0');
  const total = parseInt(searchParams.get('total') || '3');
  const passed = searchParams.get('passed') === 'true';
  const percentage = (score / total) * 100;

  return (
    <div className="animate-fade-in" style={{ 
      backgroundColor: 'var(--color-pastel-blue)', 
      minHeight: '100vh', display: 'flex', flexDirection: 'column', 
      alignItems: 'center', justifyContent: 'center', padding: '24px' 
    }}>
      
      <h1 style={{ color: '#4A4036', fontSize: '36px', marginBottom: '8px', textAlign: 'center' }}>
        {passed ? 'Level Unlocked!' : 'Challenge Completed!'}
      </h1>
      
      <div style={{ display: 'flex', gap: '8px', marginBottom: '32px' }}>
        {[1, 2, 3].map((star) => (
          <Star 
            key={star} 
            size={48} 
            color={star <= (percentage > 80 ? 3 : percentage > 40 ? 2 : 1) ? '#ffea00' : 'rgba(255,255,255,0.3)'} 
            fill={star <= (percentage > 80 ? 3 : percentage > 40 ? 2 : 1) ? '#ffea00' : 'none'} 
            className="animate-bounce-scale"
          />
        ))}
      </div>

      <Card style={{ width: '100%', textAlign: 'center', marginBottom: '32px', padding: '32px', border: '4px solid #4A4036' }}>
        <p style={{ color: '#4A4036', fontSize: '18px', marginBottom: '8px', fontWeight: 'bold' }}>Your Score</p>
        <h2 style={{ fontSize: '48px', color: '#4A4036', margin: 0 }}>{score} / {total}</h2>
        {!passed && (
          <p style={{ color: 'var(--color-error)', fontWeight: 'bold', marginTop: '16px' }}>Try again to unlock the next level!</p>
        )}
      </Card>

      <div style={{ width: '100%', display: 'flex', flexDirection: 'column', gap: '16px' }}>
        <Button size="lg" fullWidth onClick={() => router.push('/child/dashboard')} style={{ backgroundColor: 'white', color: '#4A4036' }}>
          Back to Games
        </Button>
        <Button size="lg" fullWidth variant="secondary" onClick={() => router.push('/parent')}>
          Parent Portal
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
