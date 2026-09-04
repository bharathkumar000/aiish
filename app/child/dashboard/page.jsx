"use client";
import React, { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Header from '../../../src/components/Header';
import { Tent, Home, Store, School, Building2, Castle, Lock } from 'lucide-react';
import { useAppContext } from '../../../src/context/AppContext';

// Candy Crush Style Map Nodes
const mapNodes = [
  { id: 'phoneme', title: 'Missing Phoneme', icon: <Tent size={40} color="white" strokeWidth={2.5} />, align: 'flex-start' },
  { id: 'syllable', title: 'Missing Syllable', icon: <Home size={40} color="white" strokeWidth={2.5} />, align: 'center' },
  { id: 'word', title: 'Missing Word', icon: <Store size={40} color="white" strokeWidth={2.5} />, align: 'flex-end' },
  { id: 'sentence', title: 'Sentence Completion', icon: <School size={40} color="white" strokeWidth={2.5} />, align: 'center' },
  { id: 'closure', title: 'Auditory Closure', icon: <Building2 size={40} color="white" strokeWidth={2.5} />, align: 'flex-start' },
];

export default function ChildDashboard() {
  const router = useRouter();
  const { unlockedModules } = useAppContext();

  // Scroll to bottom on mount
  useEffect(() => {
    window.scrollTo(0, document.body.scrollHeight);
  }, []);

  const isCastleUnlocked = Object.values(unlockedModules).every(val => val === true);

  return (
    <div style={{ 
      background: 'linear-gradient(to bottom, #87CEEB 0%, #A2E4B8 20%, #76C893 100%)', 
      minHeight: '100vh', paddingBottom: '60px', overflowX: 'hidden'
    }}>
      <Header title="Your Journey" />
      
      <div style={{ 
        padding: '40px 24px', display: 'flex', flexDirection: 'column-reverse', 
        gap: '60px', position: 'relative', width: '100%', maxWidth: '500px', margin: '0 auto'
      }}>
        
        {/* Curvy Path Background using SVG */}
        <svg 
          style={{ position: 'absolute', top: 0, bottom: 0, left: 0, width: '100%', height: '100%', zIndex: 0 }}
          preserveAspectRatio="none"
        >
          <path 
            d="M 50 800 C 150 700, 350 650, 250 500 C 150 350, 350 250, 250 100 C 150 -50, 250 -100, 250 -200" 
            fill="none" 
            stroke="#FFB6C1" 
            strokeWidth="24"
            strokeLinecap="round"
          />
          <path 
            d="M 50 800 C 150 700, 350 650, 250 500 C 150 350, 350 250, 250 100 C 150 -50, 250 -100, 250 -200" 
            fill="none" 
            stroke="#FF69B4" 
            strokeWidth="12"
            strokeLinecap="round"
            strokeDasharray="20, 20"
          />
        </svg>

        {mapNodes.map((node, index) => {
          const isUnlocked = unlockedModules[node.id];
          
          return (
            <div 
              key={node.id}
              onClick={() => isUnlocked && router.push(`/child/level/${node.id}`)}
              style={{
                alignSelf: node.align,
                display: 'flex', flexDirection: 'column', alignItems: 'center',
                cursor: isUnlocked ? 'pointer' : 'not-allowed',
                opacity: isUnlocked ? 1 : 0.8,
                zIndex: 1, position: 'relative',
                transform: `scale(${isUnlocked ? 1 : 0.9})`,
                transition: 'transform 0.2s'
              }}
            >
              {/* Glossy Circular Button (Candy Crush Style) */}
              <div className={isUnlocked ? "animate-bounce-scale" : ""} style={{
                background: isUnlocked ? 'radial-gradient(circle at 30% 30%, #FF69B4, #C71585)' : '#9ca3af',
                width: '90px', height: '90px', borderRadius: '50%',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                border: '4px solid white', 
                boxShadow: isUnlocked 
                  ? '0px 8px 0px #8B008B, 0px 12px 15px rgba(0,0,0,0.4), inset 0px 8px 10px rgba(255,255,255,0.5)'
                  : '0px 8px 0px #4b5563, 0px 12px 15px rgba(0,0,0,0.4)',
                marginBottom: '16px',
                position: 'relative'
              }}>
                {isUnlocked ? node.icon : <Lock size={40} color="white" />}
                
                {/* 3 Stars Container underneath */}
                <div style={{ position: 'absolute', bottom: -20, display: 'flex', gap: '4px' }}>
                  <div style={{ color: '#FFD700', textShadow: '1px 1px 0 #000' }}>⭐</div>
                  <div style={{ color: '#FFD700', textShadow: '1px 1px 0 #000', transform: 'translateY(5px)' }}>⭐</div>
                  <div style={{ color: '#FFD700', textShadow: '1px 1px 0 #000' }}>⭐</div>
                </div>
              </div>

              {/* Number Badge */}
              <div style={{
                position: 'absolute', top: -10, right: -10,
                background: 'linear-gradient(to bottom, #FFD700, #FFA500)', 
                borderRadius: '50%', width: 36, height: 36,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                border: '2px solid white', fontWeight: '900', fontSize: '18px', color: 'white',
                boxShadow: '0px 4px 0px #D2691E'
              }}>
                {index + 1}
              </div>
            </div>
          );
        })}

        {/* Final Castle Node */}
        <div 
          onClick={() => isCastleUnlocked && alert("You beat the game!")}
          style={{
            alignSelf: 'center', display: 'flex', flexDirection: 'column', alignItems: 'center',
            cursor: isCastleUnlocked ? 'pointer' : 'not-allowed',
            opacity: isCastleUnlocked ? 1 : 0.8,
            zIndex: 1, position: 'relative', marginTop: '40px'
          }}
        >
          <div className={isCastleUnlocked ? "animate-bounce-scale" : ""} style={{
             background: isCastleUnlocked ? 'radial-gradient(circle at 30% 30%, #FFD700, #FFA500)' : '#9ca3af',
             width: '120px', height: '120px', borderRadius: '50%',
             display: 'flex', alignItems: 'center', justifyContent: 'center',
             border: '6px solid white', 
             boxShadow: isCastleUnlocked 
               ? '0px 10px 0px #D2691E, 0px 15px 20px rgba(0,0,0,0.4), inset 0px 10px 15px rgba(255,255,255,0.6)'
               : '0px 10px 0px #4b5563, 0px 15px 20px rgba(0,0,0,0.4)'
          }}>
            <Castle size={64} color="white" strokeWidth={2.5} />
          </div>
          <div style={{
            background: 'white', padding: '6px 20px', borderRadius: '24px',
            border: '4px solid #FFA500', fontWeight: '900', fontSize: '18px',
            color: '#FFA500', boxShadow: '0px 6px 0px #D2691E', marginTop: '20px'
          }}>
            Final Castle
          </div>
        </div>

      </div>
    </div>
  );
}
