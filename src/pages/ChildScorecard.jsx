import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import Button from '../components/Button';
import Card from '../components/Card';
import { Star } from 'lucide-react';

export default function ChildScorecard() {
  const location = useLocation();
  const navigate = useNavigate();
  
  const score = location.state?.score || 0;
  const total = location.state?.total || 3;
  const passed = location.state?.passed || false;
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
        <Button size="lg" fullWidth onClick={() => navigate('/child/dashboard')} style={{ backgroundColor: 'white', color: '#4A4036' }}>
          Back to Games
        </Button>
        <Button size="lg" fullWidth variant="secondary" onClick={() => navigate('/parent')}>
          Parent Portal
        </Button>
      </div>
      
    </div>
  );
}
