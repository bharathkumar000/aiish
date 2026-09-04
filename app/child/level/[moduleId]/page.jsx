"use client";
import React from 'react';
import { useParams, useRouter } from 'next/navigation';
import { Play, X } from 'lucide-react';
import { useAppContext } from '../../../../src/context/AppContext';

export default function LevelStartModal() {
  const { moduleId } = useParams();
  const router = useRouter();
  const { unlockedLevels } = useAppContext();
  
  const levels = ['Level 1', 'Level 2', 'Level 3'];
  const moduleUnlockedLevels = unlockedLevels[moduleId] || {};

  return (
    <div style={{ 
      position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
      backgroundColor: 'rgba(0, 0, 0, 0.7)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      zIndex: 1000, padding: '24px'
    }}>
      {/* Candy Crush Style Modal */}
      <div className="animate-bounce-scale" style={{
        background: 'linear-gradient(to bottom, #FFE4E1, #FFC0CB)',
        width: '100%', maxWidth: '400px',
        borderRadius: '32px', border: '8px solid white',
        boxShadow: '0px 15px 0px #FF69B4, 0px 20px 25px rgba(0,0,0,0.5)',
        position: 'relative', padding: '24px', textAlign: 'center'
      }}>
        
        {/* Close Button */}
        <button onClick={() => router.push('/child/dashboard')} style={{
          position: 'absolute', top: -15, right: -15,
          background: '#FF1493', border: '4px solid white', borderRadius: '50%',
          width: '40px', height: '40px', display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0px 4px 0px #C71585', cursor: 'pointer', color: 'white'
        }}>
          <X size={24} strokeWidth={3} />
        </button>

        {/* Glossy Title Banner */}
        <div style={{
          position: 'absolute', top: -30, left: '50%', transform: 'translateX(-50%)',
          background: 'linear-gradient(to bottom, #87CEEB, #4682B4)',
          border: '4px solid white', borderRadius: '24px', padding: '8px 32px',
          boxShadow: '0px 6px 0px #4169E1', whiteSpace: 'nowrap'
        }}>
          <h2 style={{ color: 'white', margin: 0, fontSize: '24px', fontWeight: '900', textShadow: '2px 2px 0 #000' }}>
            Level {moduleId}
          </h2>
        </div>

        <div style={{ marginTop: '30px', marginBottom: '24px', background: 'white', padding: '24px', borderRadius: '24px', border: '4px solid #FFB6C1' }}>
           <h3 style={{ color: '#C71585', margin: 0, fontSize: '20px' }}>Select a challenge!</h3>
           
           <div style={{ display: 'flex', justifyContent: 'center', gap: '16px', marginTop: '20px' }}>
              {levels.map((lvl, idx) => {
                const isUnlocked = moduleUnlockedLevels[idx];
                return (
                  <div key={idx} onClick={() => isUnlocked && router.push(`/child/training/${moduleId}/${idx}`)} style={{
                    width: '60px', height: '60px', borderRadius: '50%',
                    background: isUnlocked ? 'radial-gradient(circle, #00BFFF, #1E90FF)' : '#d1d5db',
                    border: '3px solid white', display: 'flex', alignItems: 'center', justifyContent: 'center',
                    boxShadow: isUnlocked ? '0px 6px 0px #0000CD' : '0px 6px 0px #9ca3af',
                    color: 'white', fontWeight: 'bold', fontSize: '20px', cursor: isUnlocked ? 'pointer' : 'not-allowed',
                    opacity: isUnlocked ? 1 : 0.6
                  }}>
                    {idx + 1}
                  </div>
                )
              })}
           </div>
        </div>

        {/* Glossy Play Button */}
        <button 
          onClick={() => {
            // Find first uncompleted level
            const nextIdx = [0, 1, 2].find(idx => moduleUnlockedLevels[idx] && !moduleUnlockedLevels[idx+1]) || 0;
            router.push(`/child/training/${moduleId}/${nextIdx}`);
          }}
          style={{
          background: 'linear-gradient(to bottom, #FF1493, #C71585)',
          border: '4px solid white', borderRadius: '40px', padding: '12px 48px',
          boxShadow: '0px 8px 0px #8B008B, inset 0px 6px 8px rgba(255,255,255,0.4)',
          color: 'white', fontSize: '28px', fontWeight: '900', fontFamily: 'var(--font-fredoka)',
          textShadow: '2px 2px 0px rgba(0,0,0,0.3)', cursor: 'pointer',
          transition: 'transform 0.1s'
        }}>
          Play!
        </button>

      </div>
    </div>
  );
}
