import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import Header from '../components/Header';
import Card from '../components/Card';
import { Play, Lock } from 'lucide-react';
import { useAppContext } from '../context/AppContext';

const subLevels = {
  phoneme: ['Initial Omission', 'Medial Omission', 'Final Omission', 'Phoneme Blending', 'Speech in Noise'],
  syllable: ['Initial Syllable', 'Medial Syllable', 'Final Syllable'],
  // Add others as needed
};

export default function ChildLevelSelect() {
  const { moduleId } = useParams();
  const navigate = useNavigate();
  const { unlockedLevels } = useAppContext();
  
  const levels = subLevels[moduleId] || ['Level 1', 'Level 2', 'Level 3'];
  const moduleUnlockedLevels = unlockedLevels[moduleId] || {};

  return (
    <div style={{ backgroundColor: 'var(--color-bg-primary)', minHeight: '100vh' }}>
      <Header title="Select Level" showBack />
      
      <div style={{ padding: '0 24px 24px', display: 'flex', flexDirection: 'column', gap: '16px' }}>
        {levels.map((level, idx) => {
          const isUnlocked = moduleUnlockedLevels[idx];
          
          return (
            <Card 
              key={idx}
              onClick={() => isUnlocked && navigate(`/child/training/${moduleId}/${idx}`)}
              style={{ 
                display: 'flex', justifyContent: 'space-between', alignItems: 'center',
                backgroundColor: isUnlocked ? 'white' : '#e5e7eb',
                opacity: isUnlocked ? 1 : 0.6,
                cursor: isUnlocked ? 'pointer' : 'not-allowed'
              }}
            >
              <span style={{ fontSize: '18px', fontWeight: '700', color: '#4A4036' }}>{level}</span>
              <div style={{ 
                backgroundColor: isUnlocked ? 'var(--color-primary)' : '#9ca3af', 
                borderRadius: '50%', padding: '8px',
                border: '3px solid #4A4036',
                display: 'flex', alignItems: 'center', justifyContent: 'center'
              }}>
                {isUnlocked ? <Play size={20} color="#4A4036" fill="#4A4036" /> : <Lock size={20} color="#4A4036" />}
              </div>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
