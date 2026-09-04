"use client";
import React from 'react';
import { useParams, useRouter } from 'next/navigation';
import { Play, ArrowLeft } from 'lucide-react';
import { useAppContext } from '../../../../src/context/AppContext';

const subLevels = {
  phoneme: ['Initial Omission', 'Medial Omission', 'Final Omission', 'Phoneme Blending', 'Speech in Noise'],
  syllable: ['Initial Syllable', 'Medial Syllable', 'Final Syllable'],
  word: ['Level 1', 'Level 2', 'Level 3'],
  sentence: ['Level 1', 'Level 2', 'Level 3'],
  closure: ['Level 1', 'Level 2', 'Level 3'],
};

export default function LevelSelect() {
  const { moduleId } = useParams();
  const router = useRouter();
  const { unlockedLevels } = useAppContext();
  
  const levels = subLevels[moduleId] || ['Level 1', 'Level 2', 'Level 3'];
  const moduleUnlockedLevels = unlockedLevels[moduleId] || {};

  return (
    <div style={{ backgroundColor: '#F8F1E5', minHeight: '100vh', padding: '24px', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
      
      {/* Title Banner */}
      <div style={{
        backgroundColor: '#C5D4E1', width: '100%', maxWidth: '400px', 
        padding: '16px', borderRadius: '0 0 24px 24px', border: '5px solid #4A4036',
        borderTop: 'none', marginBottom: '32px', display: 'flex', alignItems: 'center', justifyContent: 'center',
        boxShadow: '0px 6px 0px #4A4036', position: 'relative', top: '-24px'
      }}>
        <button 
          onClick={() => router.push('/child/dashboard')}
          style={{ position: 'absolute', left: '16px', background: '#FCD5CE', border: '4px solid #4A4036', borderRadius: '50%', width: '40px', height: '40px', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer' }}
        >
          <ArrowLeft size={24} color="#4A4036" />
        </button>
        <h1 style={{ margin: 0, color: '#4A4036', fontSize: '24px', fontWeight: '900' }}>Select Level</h1>
      </div>
      
      <div style={{ width: '100%', maxWidth: '400px', display: 'flex', flexDirection: 'column', gap: '20px' }}>
        {levels.map((level, idx) => {
          const isUnlocked = moduleUnlockedLevels[idx];
          
          return (
            <div 
              key={idx}
              onClick={() => isUnlocked && router.push(`/child/training/${moduleId}/${idx}`)}
              style={{
                backgroundColor: 'white',
                border: '5px solid #4A4036',
                borderRadius: '16px',
                padding: '16px 20px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                cursor: isUnlocked ? 'pointer' : 'not-allowed',
                opacity: isUnlocked ? 1 : 0.6,
                boxShadow: isUnlocked ? '0px 6px 0px #4A4036' : '0px 6px 0px rgba(74, 64, 54, 0.4)',
                transform: 'translateY(0)',
                transition: 'transform 0.1s, box-shadow 0.1s',
              }}
              onMouseDown={(e) => {
                if (isUnlocked) {
                  e.currentTarget.style.transform = 'translateY(6px)';
                  e.currentTarget.style.boxShadow = '0px 0px 0px #4A4036';
                }
              }}
              onMouseUp={(e) => {
                if (isUnlocked) {
                  e.currentTarget.style.transform = 'translateY(0)';
                  e.currentTarget.style.boxShadow = '0px 6px 0px #4A4036';
                }
              }}
              onMouseLeave={(e) => {
                if (isUnlocked) {
                  e.currentTarget.style.transform = 'translateY(0)';
                  e.currentTarget.style.boxShadow = '0px 6px 0px #4A4036';
                }
              }}
            >
              <h2 style={{ margin: 0, color: '#4A4036', fontSize: '18px', fontWeight: '900' }}>
                {level}
              </h2>
              
              <div style={{ 
                backgroundColor: isUnlocked ? '#FCD5CE' : '#E5E7EB', borderRadius: '50%', width: '40px', height: '40px',
                display: 'flex', alignItems: 'center', justifyContent: 'center'
              }}>
                <Play size={20} fill={isUnlocked ? "#FFFFFF" : "#9CA3AF"} color={isUnlocked ? "#FFFFFF" : "#9CA3AF"} />
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
