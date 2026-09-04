import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import Header from '../components/Header';
import { Tent, Home, Store, School, Building2, Castle, Lock } from 'lucide-react';
import { useAppContext } from '../context/AppContext';

// Candy Crush Style Map Nodes (Starting from bottom)
const mapNodes = [
  { id: 'phoneme', title: 'Missing Phoneme', icon: <Tent size={48} color="#4A4036" strokeWidth={2.5} />, color: 'var(--color-pastel-peach)', align: 'flex-start' },
  { id: 'syllable', title: 'Missing Syllable', icon: <Home size={48} color="#4A4036" strokeWidth={2.5} />, color: 'var(--color-pastel-green)', align: 'center' },
  { id: 'word', title: 'Missing Word', icon: <Store size={48} color="#4A4036" strokeWidth={2.5} />, color: 'var(--color-pastel-blue)', align: 'flex-end' },
  { id: 'sentence', title: 'Sentence Completion', icon: <School size={48} color="#4A4036" strokeWidth={2.5} />, color: 'var(--color-pastel-pink)', align: 'center' },
  { id: 'closure', title: 'Auditory Closure', icon: <Building2 size={48} color="#4A4036" strokeWidth={2.5} />, color: 'var(--color-pastel-yellow)', align: 'flex-start' },
];

export default function ChildDashboard() {
  const navigate = useNavigate();
  const { unlockedModules } = useAppContext();

  // Scroll to bottom on mount so they see the start of the path
  useEffect(() => {
    window.scrollTo(0, document.body.scrollHeight);
  }, []);

  // Determine if castle is unlocked
  const isCastleUnlocked = Object.values(unlockedModules).every(val => val === true);

  return (
    <div style={{ backgroundColor: 'var(--color-bg-primary)', minHeight: '100vh', paddingBottom: '40px' }}>
      <Header title="Your Journey" />
      
      <div style={{ 
        padding: '24px 40px', display: 'flex', flexDirection: 'column-reverse', 
        gap: '40px', position: 'relative' 
      }}>
        
        {/* Background SVG for the winding path (Simplified dashed line) */}
        <div style={{
          position: 'absolute', top: 80, bottom: 80, left: '50%', 
          width: '4px', backgroundColor: 'transparent',
          borderLeft: '6px dashed #d4c4b7', transform: 'translateX(-50%)', zIndex: 0
        }} />

        {mapNodes.map((node, index) => {
          const isUnlocked = unlockedModules[node.id];
          
          return (
            <div 
              key={node.id}
              onClick={() => isUnlocked && navigate(`/child/level/${node.id}`)}
              style={{
                alignSelf: node.align,
                display: 'flex', flexDirection: 'column', alignItems: 'center',
                cursor: isUnlocked ? 'pointer' : 'not-allowed',
                opacity: isUnlocked ? 1 : 0.6,
                zIndex: 1, position: 'relative',
                transform: `scale(${isUnlocked ? 1 : 0.9})`
              }}
            >
              {/* The Building Icon (Node) */}
              <div className={isUnlocked ? "animate-bounce-scale" : ""} style={{
                backgroundColor: isUnlocked ? node.color : '#e5e7eb',
                width: '100px', height: '100px', borderRadius: '50%',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                border: '4px solid #4A4036', boxShadow: '4px 6px 0px #4A4036',
                marginBottom: '12px',
                position: 'relative'
              }}>
                {isUnlocked ? node.icon : <Lock size={40} color="#4A4036" />}
                
                {/* Level number badge */}
                <div style={{
                  position: 'absolute', bottom: -10, right: -10,
                  backgroundColor: 'white', borderRadius: '50%', width: 36, height: 36,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  border: '3px solid #4A4036', fontWeight: '900', fontSize: '18px'
                }}>
                  {index + 1}
                </div>
              </div>

              {/* Title Badge */}
              <div style={{
                backgroundColor: 'white', padding: '4px 12px', borderRadius: '16px',
                border: '2px solid #4A4036', fontWeight: 'bold', fontSize: '14px',
                whiteSpace: 'nowrap', textAlign: 'center', boxShadow: '2px 2px 0px #4A4036'
              }}>
                {node.title}
              </div>
            </div>
          );
        })}

        {/* Final Castle */}
        <div 
          onClick={() => isCastleUnlocked && alert("You beat the game!")}
          style={{
            alignSelf: 'center', display: 'flex', flexDirection: 'column', alignItems: 'center',
            cursor: isCastleUnlocked ? 'pointer' : 'not-allowed',
            opacity: isCastleUnlocked ? 1 : 0.6,
            zIndex: 1, position: 'relative', marginTop: '40px'
          }}
        >
          <div className={isCastleUnlocked ? "animate-bounce-scale" : ""} style={{
            backgroundColor: isCastleUnlocked ? '#FFD700' : '#e5e7eb',
            width: '120px', height: '120px', borderRadius: '50%',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            border: '4px solid #4A4036', boxShadow: '4px 6px 0px #4A4036',
            marginBottom: '12px'
          }}>
            <Castle size={64} color="#4A4036" strokeWidth={2} />
          </div>
          <div style={{
            backgroundColor: 'white', padding: '6px 16px', borderRadius: '16px',
            border: '3px solid #4A4036', fontWeight: '900', fontSize: '18px',
            color: '#4A4036', boxShadow: '2px 3px 0px #4A4036'
          }}>
            The Final Castle!
          </div>
        </div>

      </div>
    </div>
  );
}
