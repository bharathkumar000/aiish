import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import Header from '../components/Header';
import Button from '../components/Button';
import Card from '../components/Card';
import { Volume2, CheckCircle, XCircle, AlertCircle, Image as ImageIcon } from 'lucide-react';
import { useAppContext } from '../context/AppContext';

// Mock data for a session, first item is practice
const mockTrials = [
  { id: 'practice_1', word: 'MILK', occludedWord: 'Mil__', isPractice: true },
  { id: 1, word: 'APPLE', occludedWord: 'A__LE', isPractice: false },
  { id: 2, word: 'CAT', occludedWord: 'C_T', isPractice: false },
  { id: 3, word: 'DOG', occludedWord: 'D_G', isPractice: false },
];

export default function ChildTraining() {
  const { moduleId, levelId } = useParams();
  const navigate = useNavigate();
  const { addSessionLog, therapistConfig, unlockLevel, unlockModule } = useAppContext();
  
  const [currentTrial, setCurrentTrial] = useState(0);
  
  // Trial State
  const [playCount, setPlayCount] = useState(0);
  const [clueStage, setClueStage] = useState(0); // 0: None, 1: Audio Clue, 2: Visual Clue
  const [showFeedback, setShowFeedback] = useState(false);
  const [feedbackState, setFeedbackState] = useState(null); // 'success', 'fail_final'
  
  // Scoring
  const [score, setScore] = useState(0);
  const [trialLogs, setTrialLogs] = useState([]);

  const trial = mockTrials[currentTrial];

  const handlePlayAudio = (type) => {
    if (playCount >= 3 && type === 'training') return;
    
    // Simulate Web Audio API
    console.log(`Playing ${type} audio for ${trial.word}`);
    
    if (type === 'training') {
      setPlayCount(c => c + 1);
    }
  };

  const handleOperatorAnswer = (isCorrect) => {
    if (isCorrect) {
      if (!trial.isPractice) setScore(s => s + 1);
      setFeedbackState('success');
      setShowFeedback(true);
      logTrialResult(true);
    } else {
      // Progressive Fallback Logic
      if (clueStage === 0) {
        setClueStage(1);
      } else if (clueStage === 1) {
        setClueStage(2);
      } else if (clueStage === 2) {
        setFeedbackState('fail_final');
        setShowFeedback(true);
        logTrialResult(false);
      }
    }
  };

  const logTrialResult = (isCorrect) => {
    if (trial.isPractice) return;
    
    setTrialLogs(prev => [...prev, {
      wordId: trial.id,
      word: trial.word,
      isCorrect,
      playCount,
      clueStageReached: clueStage
    }]);
  };

  const handleNext = () => {
    setShowFeedback(false);
    setClueStage(0);
    setPlayCount(0);
    setFeedbackState(null);
    
    if (currentTrial < mockTrials.length - 1) {
      setCurrentTrial(c => c + 1);
    } else {
      // Save full session to global context
      const scoredTrials = mockTrials.filter(t => !t.isPractice).length;
      const passed = (score / scoredTrials) * 100 >= therapistConfig.passThreshold;
      
      addSessionLog({
        moduleId,
        levelId,
        score,
        total: scoredTrials,
        trials: trialLogs,
        passed
      });
      
      // Auto-unlock next logic
      let gameBeaten = false;
      if (passed) {
        const nextLevel = parseInt(levelId) + 1;
        if (nextLevel < 3) {
          // Unlock next level in current module
          unlockLevel(moduleId, String(nextLevel));
        } else {
          // Unlock next module!
          const moduleKeys = ['phoneme', 'syllable', 'word', 'sentence', 'closure'];
          const currentIndex = moduleKeys.indexOf(moduleId);
          if (currentIndex !== -1 && currentIndex < moduleKeys.length - 1) {
            const nextModule = moduleKeys[currentIndex + 1];
            unlockModule(nextModule);
            // Also ensure the first level of that module is unlocked
            unlockLevel(nextModule, '0');
          } else if (currentIndex === moduleKeys.length - 1) {
            gameBeaten = true;
          }
        }
      }
      
      if (gameBeaten) {
        navigate('/child/victory', { state: { score, total: scoredTrials } });
      } else {
        navigate('/child/scorecard', { state: { score, total: scoredTrials, moduleId, levelId, passed } });
      }
    }
  };

  // Determine Mascot State
  const getMascotAnimation = () => {
    if (feedbackState === 'success') return 'bounce';
    if (feedbackState === 'fail_final') return 'shake';
    if (clueStage > 0) return 'pulse';
    return 'none';
  };

  return (
    <div style={{ backgroundColor: 'var(--color-bg-primary)', minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Header title={trial.isPractice ? "Practice Round!" : `Trial ${currentTrial} of ${mockTrials.length - 1}`} showBack />

      <div style={{ padding: '24px', flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
        
        {/* Mascot / Visual Cue */}
        <div style={{ marginBottom: '32px', position: 'relative', animation: `${getMascotAnimation()} 1s infinite` }}>
          <img src="/mascot.png" alt="Mascot thinking" style={{ width: 120, height: 120, objectFit: 'contain' }} />
          {!showFeedback && clueStage === 0 && (
            <div style={{ 
              position: 'absolute', top: -20, right: -40, 
              backgroundColor: 'white', padding: '8px 12px', borderRadius: '16px',
              border: '3px solid #4A4036', fontWeight: 'bold'
            }}>
              Listen!
            </div>
          )}
          {clueStage === 1 && !showFeedback && (
            <div style={{ 
              position: 'absolute', top: -20, right: -60, 
              backgroundColor: 'var(--color-pastel-yellow)', padding: '8px 12px', borderRadius: '16px',
              border: '3px solid #4A4036', fontWeight: 'bold'
            }}>
              Let's hear a clue!
            </div>
          )}
        </div>

        {/* Audio Button */}
        <button 
          onClick={() => handlePlayAudio(clueStage > 0 ? 'clue' : 'training')}
          className="animate-bounce-scale"
          disabled={playCount >= 3 && clueStage === 0}
          style={{
            backgroundColor: (playCount >= 3 && clueStage === 0) ? '#9ca3af' : 'var(--color-secondary)',
            border: '4px solid #4A4036', borderRadius: '50%', width: 80, height: 80,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            boxShadow: '4px 4px 0px #4A4036', marginBottom: '16px', cursor: (playCount >= 3 && clueStage === 0) ? 'not-allowed' : 'pointer'
          }}
        >
          <Volume2 size={40} color="#4A4036" />
        </button>
        
        <p style={{ fontWeight: 'bold', color: 'var(--color-text-muted)', marginBottom: '16px' }}>
          Plays: {playCount}/3
        </p>

        {/* Clue Area */}
        {clueStage === 2 && !showFeedback && (
          <div className="animate-fade-in" style={{
            backgroundColor: 'var(--color-pastel-blue)', padding: '16px', borderRadius: '16px',
            border: '3px solid #4A4036', marginBottom: '24px', display: 'flex', alignItems: 'center', gap: '8px'
          }}>
            <ImageIcon size={24} />
            <span style={{ fontWeight: 'bold' }}>Visual Clue: [Image of {trial.word}]</span>
          </div>
        )}

        {/* Word Display (Visual Support) */}
        <Card style={{ width: '100%', textAlign: 'center', marginBottom: '32px', padding: '32px 16px', backgroundColor: 'white' }}>
          <h2 style={{ fontSize: '40px', letterSpacing: '4px', margin: 0, color: '#4A4036' }}>
            {showFeedback ? trial.word : trial.occludedWord}
          </h2>
        </Card>

        {/* Interaction Area (OPERATOR FACING) */}
        <div style={{ marginTop: 'auto', width: '100%' }}>
          {!showFeedback ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
              <p style={{ textAlign: 'center', fontSize: '12px', fontWeight: 'bold', color: 'var(--color-error)' }}>
                * FACILITATOR ONLY *
              </p>
              <div style={{ display: 'flex', gap: '16px' }}>
                <Button size="lg" variant="secondary" fullWidth onClick={() => handleOperatorAnswer(false)} style={{ backgroundColor: '#FF9999' }}>
                  INCORRECT
                </Button>
                <Button size="lg" variant="primary" fullWidth onClick={() => handleOperatorAnswer(true)} style={{ backgroundColor: '#A3D9A5' }}>
                  CORRECT
                </Button>
              </div>
            </div>
          ) : (
            <div className="animate-fade-in" style={{ textAlign: 'center' }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px', marginBottom: '16px', color: feedbackState === 'success' ? '#4ade80' : '#f87171' }}>
                {feedbackState === 'success' ? <CheckCircle size={32} /> : <AlertCircle size={32} />}
                <h3 style={{ fontSize: '24px', margin: 0 }}>
                  {feedbackState === 'success' ? 'Awesome job!' : 'Better luck next time!'}
                </h3>
              </div>
              <Button size="lg" fullWidth onClick={handleNext} style={{ backgroundColor: 'var(--color-pastel-peach)' }}>
                {currentTrial < mockTrials.length - 1 ? 'Next Word' : 'See Results!'}
              </Button>
            </div>
          )}
        </div>

      </div>
    </div>
  );
}
