"use client";
import React from 'react';
import { useRouter } from 'next/navigation';
import { Mic, BookOpen, MessageCircle, Headphones, Puzzle } from 'lucide-react';
import { useAppContext } from '../../../src/context/AppContext';

const modules = [
  { id: 'phoneme', title: 'Missing Phoneme', icon: <Mic size={32} color="#4A4036" strokeWidth={2.5} />, color: '#FCD5CE' },
  { id: 'syllable', title: 'Missing Syllable', icon: <BookOpen size={32} color="#4A4036" strokeWidth={2.5} />, color: '#D8E2DC' },
  { id: 'word', title: 'Missing Word', icon: <MessageCircle size={32} color="#4A4036" strokeWidth={2.5} />, color: '#BDE0FE' },
  { id: 'sentence', title: 'Sentence Completion', icon: <Puzzle size={32} color="#4A4036" strokeWidth={2.5} />, color: '#FFC8DD' },
  { id: 'closure', title: 'Auditory Closure', icon: <Headphones size={32} color="#4A4036" strokeWidth={2.5} />, color: '#FFF1E6' },
];

export default function ChildDashboard() {
  const router = useRouter();
  const { unlockedModules } = useAppContext();

  return (
    <div style={{ backgroundColor: '#F8F1E5', minHeight: '100vh', padding: '24px', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
      
      {/* Title Banner */}
      <div style={{
        backgroundColor: '#C5D4E1', width: '100%', maxWidth: '400px', 
        padding: '16px', borderRadius: '0 0 24px 24px', border: '5px solid #4A4036',
        borderTop: 'none', marginBottom: '32px', textAlign: 'center',
        boxShadow: '0px 6px 0px #4A4036', position: 'relative', top: '-24px'
      }}>
        <h1 style={{ margin: 0, color: '#4A4036', fontSize: '24px', fontWeight: '900' }}>Choose a Game!</h1>
      </div>
      
      <div style={{ width: '100%', maxWidth: '400px', display: 'flex', flexDirection: 'column', gap: '20px' }}>
        {modules.map((mod) => {
          const isUnlocked = unlockedModules[mod.id];
          
          return (
            <div 
              key={mod.id}
              onClick={() => isUnlocked && router.push(`/child/level/${mod.id}`)}
              style={{
                backgroundColor: mod.color,
                border: '5px solid #4A4036',
                borderRadius: '16px',
                padding: '16px 20px',
                display: 'flex',
                alignItems: 'center',
                gap: '16px',
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
              {/* Icon Circle */}
              <div style={{ 
                backgroundColor: 'white', borderRadius: '50%', width: '64px', height: '64px',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                border: '4px solid #4A4036'
              }}>
                {mod.icon}
              </div>
              
              <h2 style={{ margin: 0, color: '#4A4036', fontSize: '20px', fontWeight: '900' }}>
                {mod.title}
              </h2>
            </div>
          );
        })}
      </div>
    </div>
  );
}
