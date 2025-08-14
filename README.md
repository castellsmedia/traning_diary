        
        // Рендер заметок тренера
        function renderTrainerNotes() {
            var container = document.getElementById('trainer-notes');
            if (!container) return;
            
            container.innerHTML = '';
            
            var periodData = getPeriodData();
            var notes = [];
            
            // Анализ тренировок
            if (periodData.workouts > 0) {
                if (periodData.workouts >= 3) {
                    notes.push('✓ Хорошая частота тренировок: ' + periodData.workouts + ' сессий за период');
                } else if (periodData.workouts >= 1) {
                    notes.push('⚠️ Тренировок мало: ' + periodData.workouts + ' сессий. Цель 3+ в неделю');
                } else {
                    notes.push('❌ Нет тренировок за период. Нужно вернуться в зал!');
                }
            }
            
            // Поиск последнего жима
            var lastBenchE1RM = 0;
            for (var i = DATA.length - 1; i >= 0; i--) {
                if (DATA[i].events) {
                    for (var j = 0; j < DATA[i].events.length; j++) {
                        var event = DATA[i].events[j];
                        if (event.kind === 'workout' && event.lift === 'bench' && event.e1rm) {
                            lastBenchE1RM = event.e1rm;
                            break;
                        }
                    }
                }
                if (lastBenchE1RM > 0) break;
            }
            
            // Анализ жима лежа
            if (lastBenchE1RM > 0) {
                if (lastBenchE1RM >= 80) {
                    notes.push('🔥 Отличный жим: ' + lastBenchE1RM + 'кг e1RM');
                } else if (lastBenchE1RM >= 60) {
                    notes.push('💪 Хороший прогресс в жиме: ' + lastBenchE1RM + 'кг e1RM');
                } else {
                    notes.push('📈 Начальный уровень жима: ' + lastBenchE1RM + 'кг e1RM');
                }
                
                var progressToGoal = ((lastBenchE1RM / 100) * 100).toFixed(1);
                notes.push('🎯 Прогресс к цели 100кг: ' + progressToGoal + '%');
            } else {
                notes.push('⚡ Нужен тест максимума в жиме лежа для оценки силы');
            }
            
            // Рекомендации по системе 2019-2020
            notes.push('📋 План на завтра (14.08): ДЕНЬ 1 - Грудь + Плечи + Трицепс');
            notes.push('🎯 Жим лёжа: 60кг 4×4 (негатив 5 сек + пауза 2 сек)');
            notes.push('⏰ Цель на 4 недели: довести жим до 75-80кг');
            notes.push('📊 Прогрессия: +2.5кг каждую неделю при правильной технике');
            notes.push('💪 Система 2019-2020: волновая периодизация + специализация на жиме');
            notes.push('🔥 Ведите подробный дневник - это ключ к прогрессу!');
            
            notes.forEach(function(note) {
                var div = document.createElement('div');
                div.style.marginBottom = '12px';
                div.style.lineHeight = '1.6';
                div.innerHTML = note;
                container.appendChild(div);
            });
        }
        
        // Рендер заметок нутрициолога для сводки
        function renderNutritionistNotesSummary() {
            var container = document.getElementById('nutritionist-notes-summary');
            if (!container) return;
            
            container.innerHTML = '';
            
            var periodData = getPeriodData();
            var notes = [];
            
            // Анализ белка
            if (periodData.avgProtein > 0) {
                var targetProtein = 165; // ~1.8г/кг для 92кг
                if (periodData.avgProtein < targetProtein * 0.9) {
                    notes.push('⚠️ Белка маловато: ' + periodData.avgProtein + 'г в день. Цель ~' + targetProtein + 'г');
                } else if (periodData.avgProtein > targetProtein * 1.1) {
                    notes.push('✓ Белка достаточно: ' + periodData.avgProtein + 'г в день');
                } else {
                    notes.push('✓ Белок в норме: ' + periodData.avgProtein + 'г в день');
                }
            }
            
            // Анализ жиров
            if (periodData.avgFat > 0) {
                var targetFatMin = 55; // 0.6г/кг
                var targetFatMax = 83; // 0.9г/кг
                if (periodData.avgFat < targetFatMin) {
                    notes.push('⚠️ Жиров мало: ' + periodData.avgFat + 'г. Минимум ' + targetFatMin + 'г');
                } else if (periodData.avgFat > targetFatMax) {
                    notes.push('⚠️ Жиров многовато: ' + periodData.avgFat + 'г. Максимум ' + targetFatMax + 'г');
                } else {
                    notes.push('✓ Жиры в норме: ' + periodData.avgFat + 'г в день');
                }
            }
            
            // Анализ калорий
            if (periodData.avgKcal > 0) {
                var targetKcal = 2200;
                var diff = Math.abs(periodData.avgKcal - targetKcal);
                if (diff <= 200) {
                    notes.push('✓ Калории близки к цели: ' + periodData.avgKcal + ' ккал');
                } else if (periodData.avgKcal < targetKcal) {
                    notes.push('⚠️ Недоедание: -' + diff + ' ккал от цели');
                } else {
                    notes.push('⚠️ Переедание: +' + diff + ' ккал от цели');
                }
            }
            
            // Подсказки
            notes.push('💡 Перед тяжелым жимом: быстрые углеводы за 60-90 минут');
            notes.push('💡 После тренировки: белок + углеводы в течение 30 минут');
            notes.push('💡 Голодание в воскресенье: отличная практика для метаболизма');
            
            notes.forEach(function(note) {
                var div = document.createElement('div');
                div.style.marginBottom = '12px';
                div.style.lineHeight = '1.6';
                div.innerHTML = note;
                container.appendChild(div);
            });
        }<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>Дневник тренировок - Система Дмитрия</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            -webkit-tap-highlight-color: transparent;
        }
        
        :root {
            --bg-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --bg-secondary: rgba(255, 255, 255, 0.1);
            --bg-tertiary: rgba(255, 255, 255, 0.05);
            --bg-card: rgba(255, 255, 255, 0.15);
            --bg-glass: rgba(255, 255, 255, 0.1);
            --text-primary: #FFFFFF;
            --text-secondary: rgba(255, 255, 255, 0.8);
            --text-tertiary: rgba(255, 255, 255, 0.6);
            --accent: rgba(255, 255, 255, 0.15);
            --accent-bright: rgba(255, 255, 255, 0.25);
            --accent-dim: rgba(255, 255, 255, 0.1);
            --success: #22C55E;
            --warning: #F59E0B;
            --danger: #EF4444;
            --purple: #8B5CF6;
            --cyan: #06B6D4;
            --mint: #10B981;
            --border: rgba(255, 255, 255, 0.15);
            --border-bright: rgba(255, 255, 255, 0.2);
            --shadow-soft: 0 8px 32px rgba(0, 0, 0, 0.1);
            --shadow-hard: 0 20px 40px rgba(0, 0, 0, 0.15);
            --shadow-glow: 0 0 20px rgba(255, 255, 255, 0.1);
            --gradient-primary: rgba(255, 255, 255, 0.15);
            --gradient-secondary: linear-gradient(135deg, #22C55E 0%, #06B6D4 100%);
            --gradient-accent: linear-gradient(135deg, #EF4444 0%, #F59E0B 100%);
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: radial-gradient(circle at 20% 50%, rgba(196, 165, 116, 0.02) 0%, transparent 50%),
                        radial-gradient(circle at 80% 20%, rgba(196, 165, 116, 0.015) 0%, transparent 50%),
                        radial-gradient(circle at 40% 80%, rgba(196, 165, 116, 0.01) 0%, transparent 50%),
                        var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.5;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            font-weight: 400;
            font-size: 16px;
        }
        
        .app-container {
            width: 100%;
            max-width: 100%;
            min-height: 100vh;
            background: var(--bg-primary);
            position: relative;
            margin: 0 auto;
        }
        
        @media (min-width: 769px) {
            .app-container {
                max-width: 800px;
            }
        }
        
        @media (min-width: 1200px) {
            .app-container {
                max-width: 900px;
            }
        }
        
        .app-content {
            min-height: 100vh;
            position: relative;
        }
        
        .app-header {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(40px) saturate(1.5);
            -webkit-backdrop-filter: blur(40px) saturate(1.5);
            border-bottom: 1px solid var(--border);
            padding: 20px;
            padding-top: max(20px, env(safe-area-inset-top));
            box-shadow: 0 1px 0 0 var(--border-bright), 
                        0 8px 32px -8px rgba(0, 0, 0, 0.4);
        }
        
        .app-title {
            font-size: 28px;
            font-weight: 700;
            letter-spacing: -0.3px;
            margin-bottom: 24px;
            color: var(--text-primary);
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        

        
        @media (max-width: 768px) {
            .app-title {
                font-size: 24px;
                margin-bottom: 16px;
            }
        }
        
        .segment-control {
            display: flex;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 16px;
            padding: 4px;
            position: relative;
            border: 1px solid var(--border);
            box-shadow: inset 0 1px 0 0 var(--border), 
                        0 8px 24px -4px rgba(0, 0, 0, 0.2);
        }
        
        .segment-control button {
            flex: 1;
            padding: 12px 20px;
            background: transparent;
            border: none;
            color: var(--text-secondary);
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
            border-radius: 12px;
            position: relative;
            z-index: 2;
            overflow: hidden;
        }
        
        .segment-control button::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.1);
            opacity: 0;
            transition: opacity 0.4s cubic-bezier(0.25, 1, 0.5, 1);
            border-radius: 12px;
            z-index: -1;
        }
        
        .segment-control button.active {
            color: white;
            background: rgba(255, 255, 255, 0.15);
            text-shadow: none;
            transform: scale(1.02);
            box-shadow: var(--shadow-soft);
        }
        
        .segment-control button.active::before {
            opacity: 0;
        }
        
        .segment-control button:hover:not(.active) {
            color: var(--text-primary);
            background: rgba(255, 255, 255, 0.08);
        }
        
        .main-content {
            padding: 20px;
            min-height: calc(100vh - 200px);
            padding-bottom: max(20px, env(safe-area-inset-bottom));
        }
        
        .tab-content {
            display: none;
            animation: fadeIn 0.3s ease-in-out;
        }
        
        .tab-content.active {
            display: block;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .date-navigation {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 20px 0;
            padding: 16px;
            background: var(--bg-card);
            border-radius: 14px;
            backdrop-filter: blur(10px);
        }
        
        .nav-button {
            width: 48px;
            height: 48px;
            border-radius: 16px;
            background: var(--bg-glass);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--border);
            color: var(--accent);
            font-size: 22px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s cubic-bezier(0.25, 1, 0.5, 1);
            position: relative;
            overflow: hidden;
        }
        
        .nav-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: var(--gradient-primary);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .nav-button:hover {
            color: white;
            background: var(--accent);
            transform: scale(1.05);
            box-shadow: 0 8px 24px rgba(255, 255, 255, 0.15);
        }
        
        .nav-button:hover::before {
            opacity: 1;
        }
        
        .nav-button:active {
            transform: scale(0.95);
        }
        
        .date-label {
            font-size: 17px;
            font-weight: 600;
            text-align: center;
            flex: 1;
            color: var(--text-primary);
        }
        
        .calendar-grid {
            display: grid;
            gap: 10px;
            margin: 20px 0;
            grid-template-columns: repeat(7, 1fr);
            gap: 8px;
        }
        
        .calendar-cell {
            background: var(--bg-secondary);
            backdrop-filter: blur(20px) saturate(1.2);
            -webkit-backdrop-filter: blur(20px) saturate(1.2);
            border-radius: 16px;
            padding: 16px;
            min-height: 80px;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
            border: 1px solid var(--border);
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-soft);
        }
        
        .calendar-cell::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }
        
        .calendar-cell:hover {
            transform: translateY(-4px) scale(1.02);
            border-color: var(--accent-bright);
            box-shadow: 0 12px 32px rgba(255, 255, 255, 0.1),
                        var(--shadow-soft);
        }
        
        .calendar-cell:hover::before {
            opacity: 1;
        }
        
        .calendar-cell.active {
            background: var(--accent);
            border-color: var(--accent);
            color: white;
            text-shadow: none;
            box-shadow: 0 8px 24px rgba(255, 255, 255, 0.15),
                        var(--shadow-soft);
        }
        
        .calendar-cell.today {
            border-color: var(--success);
            box-shadow: 0 0 0 2px rgba(48, 209, 88, 0.3),
                        0 4px 16px rgba(48, 209, 88, 0.2);
        }
        
        .calendar-cell-date {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 6px;
            color: var(--text-primary);
        }
        
        .calendar-cell-info {
            font-size: 12px;
            color: var(--text-secondary);
            line-height: 1.3;
        }
        
        .timeline-container {
            display: flex;
            gap: 20px;
            margin-top: 20px;
        }
        
        .days-list {
            width: 200px;
            flex-shrink: 0;
        }
        
        @media (max-width: 768px) {
            .days-list {
                width: 140px;
            }
        }
        
        .days-list-title {
            font-size: 14px;
            color: var(--text-secondary);
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }
        
        .day-button {
            width: 100%;
            padding: 12px;
            margin-bottom: 8px;
            background: var(--bg-card);
            border: 2px solid transparent;
            border-radius: 12px;
            color: var(--text-primary);
            text-align: left;
            cursor: pointer;
            transition: all 0.3s;
            backdrop-filter: blur(10px);
        }
        
        .day-button:hover {
            background: var(--bg-tertiary);
            border-color: var(--accent);
        }
        
        .day-button.active {
            background: var(--accent);
            border-color: var(--accent);
        }
        
        .day-button-date {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 4px;
        }
        
        .day-button-info {
            font-size: 12px;
            color: var(--text-secondary);
        }
        
        .day-button.active .day-button-info {
            color: rgba(255, 255, 255, 0.8);
        }
        
        .timeline {
            flex: 1;
            background: var(--bg-secondary);
            border-radius: 16px;
            padding: 20px;
            backdrop-filter: blur(10px);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-soft);
        }
        
        .timeline-header {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
            color: var(--text-primary);
        }
        
        .timeline-item {
            display: flex;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border);
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        .timeline-item:last-child {
            border-bottom: none;
        }
        
        .timeline-time {
            width: 60px;
            flex-shrink: 0;
            font-size: 14px;
            color: var(--text-secondary);
            padding-top: 2px;
        }
        
        .timeline-content {
            flex: 1;
        }
        
        .timeline-title {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 4px;
            color: var(--text-primary);
        }
        
        .timeline-desc {
            font-size: 14px;
            color: var(--text-secondary);
            margin-bottom: 8px;
            line-height: 1.4;
        }
        
        .timeline-meta {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        .meta-badge {
            padding: 4px 12px;
            background: var(--bg-tertiary);
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            color: var(--text-secondary);
            border: 1px solid var(--border);
        }
        
        .meta-badge.accent {
            background: var(--accent);
            color: var(--text-primary);
        }
        
        .meta-badge.success {
            background: var(--success);
            color: var(--text-primary);
        }
        
        .meta-badge.warning {
            background: var(--warning);
            color: var(--text-primary);
        }
        
        .analytics-cards {
            display: grid;
            gap: 16px;
            margin-top: 20px;
        }
        
        .analytics-card {
            background: var(--bg-secondary);
            backdrop-filter: blur(30px) saturate(1.3);
            -webkit-backdrop-filter: blur(30px) saturate(1.3);
            border-radius: 20px;
            padding: 24px;
            border: 1px solid var(--border);
            transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-soft);
        }
        
        .analytics-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.02));
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }
        
        .analytics-card:hover {
            transform: translateY(-6px) scale(1.02);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08),
                        0 8px 16px rgba(255, 255, 255, 0.1),
                        var(--shadow-soft);
            border-color: var(--accent);
        }
        
        .analytics-card:hover::before {
            opacity: 1;
        }
        
        .card-title {
            font-size: 13px;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .card-value {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 4px;
            line-height: 1.1;
        }
        
        .card-subtitle {
            font-size: 13px;
            color: var(--text-secondary);
            line-height: 1.3;
        }
        
        .card-progress {
            margin-top: 12px;
            height: 8px;
            background: var(--bg-tertiary);
            border-radius: 4px;
            overflow: hidden;
            border: 1px solid var(--border);
        }
        
        .card-progress-bar {
            height: 100%;
            background: var(--accent);
            border-radius: 4px;
            transition: width 0.5s ease-out;
        }
        
        .strength-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 16px;
            margin: 20px 0;
        }
        
        @media (max-width: 768px) {
            .strength-cards {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        .strength-card {
            background: var(--bg-glass);
            backdrop-filter: blur(25px) saturate(1.2);
            -webkit-backdrop-filter: blur(25px) saturate(1.2);
            border-radius: 18px;
            padding: 20px;
            text-align: center;
            border: 1px solid var(--border);
            transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
            position: relative;
            overflow: hidden;
        }
        
        .strength-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: radial-gradient(circle at center, rgba(0, 122, 255, 0.1), transparent 70%);
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }
        
        .strength-card:hover {
            transform: scale(1.08) translateY(-2px);
            border-color: var(--accent-bright);
            box-shadow: 0 12px 32px rgba(255, 255, 255, 0.1),
                        var(--shadow-soft);
        }
        
        .strength-card:hover::before {
            opacity: 1;
        }
        
        .strength-label {
            font-size: 12px;
            color: var(--text-secondary);
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        
        .strength-value {
            font-size: 24px;
            font-weight: 700;
            color: var(--success);
            line-height: 1.1;
        }
        
        .strength-unit {
            font-size: 13px;
            color: var(--text-secondary);
            margin-top: 2px;
        }
        
        .export-buttons {
            display: flex;
            gap: 12px;
            margin: 20px 0;
        }
        
        .export-button {
            padding: 14px 28px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--border);
            border-radius: 16px;
            color: var(--text-secondary);
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
            position: relative;
            overflow: hidden;
        }
        
        .export-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: var(--gradient-primary);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .export-button:hover {
            color: white;
            background: var(--accent-bright);
            transform: scale(1.05) translateY(-2px);
            box-shadow: 0 12px 32px rgba(255, 255, 255, 0.15),
                        var(--shadow-soft);
            border-color: var(--accent-bright);
        }
        
        .export-button:hover::before {
            opacity: 1;
        }
        
        .export-button:active {
            transform: scale(0.95);
        }
        
        .date-picker-container {
            display: flex;
            gap: 12px;
            align-items: center;
            margin: 20px 0;
            padding: 16px;
            background: var(--bg-card);
            border-radius: 14px;
            backdrop-filter: blur(10px);
            flex-wrap: wrap;
        }
        
        .date-picker-label {
            font-size: 14px;
            color: var(--text-secondary);
        }
        
        .date-picker {
            padding: 8px 12px;
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 14px;
            box-shadow: var(--shadow-soft);
        }
        
        .period-selector {
            padding: 8px 12px;
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 14px;
            cursor: pointer;
            box-shadow: var(--shadow-soft);
        }
        
        .coach-summary {
            background: linear-gradient(135deg, 
                        rgba(255, 255, 255, 0.05) 0%, 
                        rgba(255, 255, 255, 0.03) 50%, 
                        rgba(255, 255, 255, 0.02) 100%), 
                        var(--bg-secondary);
            backdrop-filter: blur(40px) saturate(1.4);
            -webkit-backdrop-filter: blur(40px) saturate(1.4);
            border-radius: 24px;
            padding: 28px;
            margin: 24px 0;
            border: 1px solid var(--border);
            background-clip: padding-box;
            position: relative;
            overflow: hidden;
            box-shadow: 0 16px 48px rgba(255, 255, 255, 0.05),
                        var(--shadow-soft);
        }
        
        .coach-summary::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: none;
            z-index: -1;
        }
        
        .coach-title {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 16px;
            color: var(--success);
        }
        
        .coach-text {
            font-size: 15px;
            line-height: 1.6;
            color: var(--text-primary);
            margin-bottom: 12px;
        }
        
        .coach-highlight {
            color: var(--success);
            font-weight: 600;
        }
        
        .nutrition-goals {
            background: var(--bg-secondary);
            border-radius: 16px;
            padding: 20px;
            margin: 20px 0;
            backdrop-filter: blur(10px);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-soft);
        }
        
        .goal-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--border);
        }
        
        .goal-item:last-child {
            border-bottom: none;
        }
        
        .goal-label {
            font-size: 15px;
            color: var(--text-secondary);
            font-weight: 500;
        }
        
        .goal-value {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-primary);
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: var(--text-secondary);
        }
        
        .empty-state-icon {
            font-size: 48px;
            margin-bottom: 16px;
            opacity: 0.5;
        }
        
        .empty-state-text {
            font-size: 15px;
            color: var(--text-secondary);
            line-height: 1.4;
        }
        
        @media (max-width: 768px) {
            body {
                font-size: 15px;
            }
            
            .timeline-container {
                flex-direction: column;
            }
            
            .days-list {
                width: 100%;
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
                gap: 8px;
            }
            
            .date-picker-container {
                flex-direction: column;
                align-items: stretch;
            }
        }
        

        
        .no-select {
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }
        
        button, .nav-button, .day-button, .calendar-cell {
            -webkit-tap-highlight-color: transparent;
            -webkit-touch-callout: none;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <div class="app-content">
            <header class="app-header">
                <h1 class="app-title">Дневник тренировок</h1>
                <div class="segment-control">
                    <button class="active" data-tab="diary">Дневник</button>
                    <button data-tab="analytics">Аналитика</button>
                </div>
            </header>
            
            <main class="main-content">
                <!-- Вкладка Дневник -->
                <div id="diary-tab" class="tab-content active">
                    <div class="date-navigation">
                        <button class="nav-button" id="prev-button">‹</button>
                        <div class="date-label" id="date-label">Сегодня</div>
                        <button class="nav-button" id="next-button">›</button>
                    </div>
                    
                    <div id="calendar-container"></div>
                    
                    <div class="timeline-container">
                        <div class="days-list">
                            <div class="days-list-title">Последние дни</div>
                            <div id="days-list-content"></div>
                        </div>
                        <div class="timeline">
                            <div class="timeline-header" id="timeline-header">События дня</div>
                            <div id="timeline-content"></div>
                        </div>
                    </div>
                    
                    <div class="export-buttons">
                        <button class="export-button" id="export-json">Экспорт JSON</button>
                        <button class="export-button" id="export-csv">Экспорт CSV</button>
                    </div>
                </div>
                
                <!-- Вкладка Аналитика -->
                <div id="analytics-tab" class="tab-content">
                    <div class="date-picker-container">
                        <label class="date-picker-label">Опорная дата:</label>
                        <input type="date" class="date-picker" id="reference-date">
                        <select class="period-selector" id="period-selector">
                            <option value="day">День</option>
                            <option value="week" selected>Неделя</option>
                            <option value="month">Месяц</option>
                            <option value="quarter">Квартал</option>
                            <option value="half">Полгода</option>
                            <option value="year">Год</option>
                            <option value="all">Все время</option>
                        </select>
                        <div class="date-picker-label" id="period-label">Период</div>
                    </div>
                    
                    <div class="segment-control">
                        <button class="active" data-analytics="summary">Сводка</button>
                        <button data-analytics="nutrition">Цели</button>
                    </div>
                    
                    <!-- Подвкладка Сводка -->
                    <div id="summary-content" class="tab-content active">
                        <div class="coach-summary">
                            <h2 class="coach-title">Сводка на сегодня</h2>
                            <div id="coach-text"></div>
                        </div>
                        
                        <div class="strength-cards" id="strength-cards"></div>
                        
                        <div class="analytics-cards" id="analytics-cards"></div>
                        
                        <!-- Заметки тренера -->
                        <div class="nutrition-goals">
                            <h3 style="margin-bottom: 20px; color: var(--success);">Заметки тренера</h3>
                            <div id="trainer-notes"></div>
                        </div>
                        
                        <!-- Заметки нутрициолога -->
                        <div class="nutrition-goals">
                            <h3 style="margin-bottom: 20px; color: var(--success);">Заметки нутрициолога</h3>
                            <div id="nutritionist-notes-summary"></div>
                        </div>
                    </div>
                    
                    <!-- Подвкладка Питание/Цели -->
                    <div id="nutrition-content" class="tab-content">
                        <div class="analytics-cards">
                            <div class="analytics-card">
                                <div class="card-title">Силовая цель</div>
                                <div class="card-value">Жим лёжа 100 кг</div>
                                <div class="card-subtitle">Специализация на жиме по системе 2019-2020</div>
                                <div class="card-progress">
                                    <div class="card-progress-bar" id="bench-progress"></div>
                                </div>
                            </div>
                            
                            <div class="analytics-card">
                                <div class="card-title">Состав тела</div>
                                <div class="card-value">Жир 15%</div>
                                <div class="card-subtitle">Целевой процент жира</div>
                            </div>
                        </div>
                        
                        <div class="nutrition-goals">
                            <h3 style="margin-bottom: 20px; color: var(--success);">Питание для 15% жира</h3>
                            <div id="nutrition-calculations"></div>
                        </div>
                        
                        <div class="nutrition-goals">
                            <h3 style="margin-bottom: 20px; color: var(--success);">Заметки нутрициолога</h3>
                            <div id="nutritionist-notes"></div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <script>
    (function() {
        'use strict';
        
        // Данные приложения
        var DATA = [];
        var currentDate = new Date();
        var currentView = 'month';
        var selectedDate = new Date();
        var currentTab = 'diary';
        var currentAnalyticsTab = 'summary';
        var referencePeriod = 'week';
        
        // Инициализация данных
        function initData() {
            var today = formatDate(new Date());
            if (DATA.length === 0) {
                // Сегодня - 13.08.2025
                DATA.push({
                    date: today,
                    totals: { kcal: 1850, p: 145, f: 65, c: 180 },
                    weight: 92,
                    events: [
                        {
                            ts: today + 'T08:30:00',
                            kind: 'meal',
                            title: '3 яйца с помидорами + Lay\'s ~20г',
                            desc: 'Завтрак дома',
                            kcal: 450,
                            p: 30,
                            f: 25,
                            c: 15
                        },
                        {
                            ts: today + 'T10:00:00',
                            kind: 'workout',
                            title: 'Жим лёжа - возвращение',
                            desc: 'Негативная фаза 5 сек + пауза 2 сек',
                            lift: 'bench',
                            sets: [
                                {w: 60, r: 4},
                                {w: 60, r: 3},
                                {w: 60, r: 3},
                                {w: 60, r: 4}
                            ],
                            e1rm: 68,
                            volume: 840
                        },
                        {
                            ts: today + 'T13:00:00',
                            kind: 'meal',
                            title: 'Ланч McDonald\'s: Биг Тейсти + картофель',
                            desc: 'После тренировки',
                            kcal: 850,
                            p: 45,
                            f: 35,
                            c: 85
                        },
                        {
                            ts: today + 'T18:30:00',
                            kind: 'meal',
                            title: 'Куриная грудка с рисом',
                            desc: 'Ужин',
                            kcal: 550,
                            p: 70,
                            f: 5,
                            c: 80
                        },
                        {
                            ts: today + 'T21:00:00',
                            kind: 'metric',
                            weight: 92,
                            waist: 95,
                            steps: 8500,
                            sleep_hours: 7,
                            desc: 'Вечерние замеры'
                        }
                    ]
                });
                
                // Завтра - 14.08.2025 (День 1: Грудь + Плечи + Трицепс)
                var tomorrow = new Date();
                tomorrow.setDate(tomorrow.getDate() + 1);
                var tomorrowStr = formatDate(tomorrow);
                
                DATA.push({
                    date: tomorrowStr,
                    totals: { kcal: 2200, p: 165, f: 75, c: 200 },
                    weight: 92,
                    events: [
                        {
                            ts: tomorrowStr + 'T08:00:00',
                            kind: 'meal',
                            title: 'Завтрак: овсянка + банан + творог',
                            desc: 'Перед тренировкой',
                            kcal: 400,
                            p: 25,
                            f: 10,
                            c: 55
                        },
                        {
                            ts: tomorrowStr + 'T10:30:00',
                            kind: 'workout',
                            title: 'ДЕНЬ 1: Грудь + Плечи + Трицепс',
                            desc: 'Неделя 1 - Адаптационная. Жим с негативом 5 сек + пауза 2 сек',
                            lift: 'bench',
                            sets: [
                                {w: 60, r: 4},
                                {w: 60, r: 4},
                                {w: 60, r: 4},
                                {w: 60, r: 4}
                            ],
                            e1rm: 68,
                            volume: 960,
                            exercises: [
                                'Жим лёжа (негатив 5с + пауза 2с): 60кг 4×4',
                                'Жим гантелей на наклонной: 3×12',
                                'Разводка гантелей: 3×15',
                                'Махи через стороны: 4×15',
                                'Жим гантелей сидя: 3×12',
                                'Трицепс на блоке: 4×15'
                            ]
                        },
                        {
                            ts: tomorrowStr + 'T12:00:00',
                            kind: 'meal',
                            title: 'Протеиновый коктейль + банан',
                            desc: 'После тренировки',
                            kcal: 300,
                            p: 30,
                            f: 5,
                            c: 35
                        },
                        {
                            ts: tomorrowStr + 'T14:30:00',
                            kind: 'meal',
                            title: 'Обед: курица + рис + овощи',
                            desc: 'Основной прием пищи',
                            kcal: 700,
                            p: 60,
                            f: 15,
                            c: 80
                        },
                        {
                            ts: tomorrowStr + 'T17:00:00',
                            kind: 'meal',
                            title: 'Перекус: орехи + яблоко',
                            desc: 'Полдник',
                            kcal: 250,
                            p: 8,
                            f: 18,
                            c: 20
                        },
                        {
                            ts: tomorrowStr + 'T19:30:00',
                            kind: 'meal',
                            title: 'Ужин: рыба + гречка + салат',
                            desc: 'Ужин',
                            kcal: 550,
                            p: 42,
                            f: 22,
                            c: 40
                        },
                        {
                            ts: tomorrowStr + 'T21:00:00',
                            kind: 'metric',
                            weight: 92,
                            waist: 95,
                            steps: 9000,
                            sleep_hours: 8,
                            desc: 'Утренний вес и замеры'
                        }
                    ]
                });
                
                // Послезавтра - 15.08.2025 (День 2: Спина + Бицепс)
                var dayAfter = new Date();
                dayAfter.setDate(dayAfter.getDate() + 2);
                var dayAfterStr = formatDate(dayAfter);
                
                DATA.push({
                    date: dayAfterStr,
                    totals: { kcal: 2150, p: 160, f: 70, c: 195 },
                    weight: 92,
                    events: [
                        {
                            ts: dayAfterStr + 'T08:00:00',
                            kind: 'meal',
                            title: 'Завтрак: яичница + хлеб + авокадо',
                            desc: 'Завтрак',
                            kcal: 450,
                            p: 20,
                            f: 25,
                            c: 35
                        },
                        {
                            ts: dayAfterStr + 'T10:30:00',
                            kind: 'workout',
                            title: 'ДЕНЬ 2: Спина + Бицепс',
                            desc: 'Неделя 1 - Развитие тяговых движений',
                            lift: 'pullup',
                            sets: [
                                {w: 0, r: 8},
                                {w: 0, r: 7},
                                {w: 0, r: 6},
                                {w: 0, r: 8}
                            ],
                            volume: 0,
                            exercises: [
                                'Вертикальная тяга (параллельный хват): 4×12',
                                'Горизонтальная тяга: 4×15',
                                'Тяга гантели в наклоне: 3×12',
                                'Махи в наклоне (задняя дельта): 4×15',
                                'Сгибания рук с гантелями: 4×12',
                                'Гиперэкстензии: 3×20'
                            ]
                        },
                        {
                            ts: dayAfterStr + 'T12:00:00',
                            kind: 'meal',
                            title: 'Творог + ягоды',
                            desc: 'После тренировки',
                            kcal: 250,
                            p: 25,
                            f: 8,
                            c: 20
                        },
                        {
                            ts: dayAfterStr + 'T14:30:00',
                            kind: 'meal',
                            title: 'Обед: говядина + картофель + салат',
                            desc: 'Основной прием пищи',
                            kcal: 650,
                            p: 50,
                            f: 18,
                            c: 65
                        },
                        {
                            ts: dayAfterStr + 'T17:00:00',
                            kind: 'meal',
                            title: 'Перекус: йогурт + орехи',
                            desc: 'Полдник',
                            kcal: 300,
                            p: 15,
                            f: 20,
                            c: 25
                        },
                        {
                            ts: dayAfterStr + 'T19:30:00',
                            kind: 'meal',
                            title: 'Ужин: курица + овощи на пару',
                            desc: 'Легкий ужин',
                            kcal: 500,
                            p: 50,
                            f: 15,
                            c: 30
                        },
                        {
                            ts: dayAfterStr + 'T21:00:00',
                            kind: 'metric',
                            weight: 91.8,
                            waist: 95,
                            steps: 8800,
                            sleep_hours: 7.5,
                            desc: 'Вечерние замеры'
                        }
                    ]
                });
                
                // 16.08.2025 (День 3: Ноги - опционально)
                var day3 = new Date();
                day3.setDate(day3.getDate() + 3);
                var day3Str = formatDate(day3);
                
                DATA.push({
                    date: day3Str,
                    totals: { kcal: 2000, p: 150, f: 65, c: 180 },
                    weight: 91.5,
                    events: [
                        {
                            ts: day3Str + 'T08:00:00',
                            kind: 'meal',
                            title: 'Завтрак: овсянка + фрукты',
                            desc: 'Легкий завтрак',
                            kcal: 350,
                            p: 12,
                            f: 8,
                            c: 65
                        },
                        {
                            ts: day3Str + 'T10:30:00',
                            kind: 'workout',
                            title: 'ДЕНЬ 3: Ноги (опционально)',
                            desc: 'Неделя 1 - Легкая тренировка ног',
                            lift: 'squat',
                            sets: [
                                {w: 60, r: 15},
                                {w: 60, r: 15},
                                {w: 60, r: 15},
                                {w: 60, r: 15}
                            ],
                            volume: 3600,
                            exercises: [
                                'Жим ногами: 4×15',
                                'Сгибания ног: 4×15',
                                'Разгибания ног: 4×15',
                                'Икры: 4×20'
                            ]
                        },
                        {
                            ts: day3Str + 'T14:00:00',
                            kind: 'meal',
                            title: 'Обед: рыба + рис + овощи',
                            desc: 'Обед после тренировки',
                            kcal: 600,
                            p: 45,
                            f: 12,
                            c: 70
                        },
                        {
                            ts: day3Str + 'T17:00:00',
                            kind: 'meal',
                            title: 'Перекус: протеиновый батончик',
                            desc: 'Перекус',
                            kcal: 250,
                            p: 20,
                            f: 8,
                            c: 25
                        },
                        {
                            ts: day3Str + 'T19:30:00',
                            kind: 'meal',
                            title: 'Ужин: курица + салат',
                            desc: 'Легкий ужин',
                            kcal: 400,
                            p: 40,
                            f: 12,
                            c: 20
                        },
                        {
                            ts: day3Str + 'T21:00:00',
                            kind: 'metric',
                            weight: 91.5,
                            waist: 94,
                            steps: 10500,
                            sleep_hours: 8,
                            desc: 'Замеры после тренировки ног'
                        }
                    ]
                });
            }
        }
        
        // Форматирование даты
        function formatDate(date) {
            var year = date.getFullYear();
            var month = String(date.getMonth() + 1).padStart(2, '0');
            var day = String(date.getDate()).padStart(2, '0');
            return year + '-' + month + '-' + day;
        }
        
        // Форматирование времени
        function formatTime(timestamp) {
            var parts = timestamp.split('T');
            if (parts.length > 1) {
                return parts[1].substring(0, 5);
            }
            return '00:00';
        }
        
        // Получение данных для даты
        function getDataForDate(date) {
            var dateStr = formatDate(date);
            for (var i = 0; i < DATA.length; i++) {
                if (DATA[i].date === dateStr) {
                    return DATA[i];
                }
            }
            return null;
        }
        
        // Рендер календаря
        function renderCalendar() {
            var container = document.getElementById('calendar-container');
            if (!container) return;
            
            container.innerHTML = '';
            renderMonthView(container);
        }
        
        // Рендер месячного вида
        function renderMonthView(container) {
            var grid = document.createElement('div');
            grid.className = 'calendar-grid';
            
            var year = selectedDate.getFullYear();
            var month = selectedDate.getMonth();
            var firstDay = new Date(year, month, 1);
            var lastDay = new Date(year, month + 1, 0);
            var startDate = new Date(firstDay);
            var startDay = startDate.getDay();
            startDate.setDate(startDate.getDate() - (startDay === 0 ? 6 : startDay - 1));
            
            // Заголовки дней недели
            var weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
            weekDays.forEach(function(day) {
                var header = document.createElement('div');
                header.style.textAlign = 'center';
                header.style.fontWeight = '600';
                header.style.fontSize = '12px';
                header.style.color = 'var(--text-secondary)';
                header.textContent = day;
                grid.appendChild(header);
            });
            
            // Дни месяца
            for (var d = new Date(startDate); d <= lastDay || d.getDay() !== 1; d.setDate(d.getDate() + 1)) {
                var cell = document.createElement('div');
                cell.className = 'calendar-cell';
                
                if (d.getMonth() !== month) {
                    cell.style.opacity = '0.3';
                }
                
                if (formatDate(d) === formatDate(new Date())) {
                    cell.classList.add('today');
                }
                
                if (formatDate(d) === formatDate(selectedDate)) {
                    cell.classList.add('active');
                }
                
                var dayData = getDataForDate(new Date(d));
                
                cell.innerHTML = '<div class="calendar-cell-date">' + d.getDate() + '</div>';
                
                if (dayData && dayData.totals) {
                    var info = document.createElement('div');
                    info.className = 'calendar-cell-info';
                    info.textContent = dayData.totals.kcal + ' ккал';
                    cell.appendChild(info);
                }
                
                cell.dataset.date = formatDate(new Date(d));
                cell.addEventListener('click', function() {
                    selectedDate = new Date(this.dataset.date);
                    renderCalendar();
                    renderTimeline();
                });
                
                grid.appendChild(cell);
            }
            
            container.appendChild(grid);
        }
        
        // Рендер списка дней
        function renderDaysList() {
            var container = document.getElementById('days-list-content');
            if (!container) return;
            
            container.innerHTML = '';
            
            // Показываем последние 7 дней
            for (var i = 0; i < 7; i++) {
                var date = new Date();
                date.setDate(date.getDate() - i);
                
                var dayData = getDataForDate(date);
                
                var button = document.createElement('button');
                button.className = 'day-button';
                
                if (formatDate(date) === formatDate(selectedDate)) {
                    button.classList.add('active');
                }
                
                var dateStr = formatDate(date);
                var dayName = i === 0 ? 'Сегодня' : i === 1 ? 'Вчера' : 
                    date.toLocaleDateString('ru', { weekday: 'short', day: 'numeric' });
                
                button.innerHTML = 
                    '<div class="day-button-date">' + dayName + '</div>' +
                    '<div class="day-button-info">' + 
                    (dayData && dayData.totals ? dayData.totals.kcal + ' ккал' : 'Нет данных') +
                    '</div>';
                
                button.dataset.date = dateStr;
                button.addEventListener('click', function() {
                    selectedDate = new Date(this.dataset.date);
                    renderDaysList();
                    renderTimeline();
                });
                
                container.appendChild(button);
            }
        }
        
        // Рендер таймлайна
        function renderTimeline() {
            var container = document.getElementById('timeline-content');
            var header = document.getElementById('timeline-header');
            if (!container || !header) return;
            
            container.innerHTML = '';
            
            var dateStr = selectedDate.toLocaleDateString('ru', { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            });
            header.textContent = 'События - ' + dateStr;
            
            var dayData = getDataForDate(selectedDate);
            
            if (!dayData || !dayData.events || dayData.events.length === 0) {
                container.innerHTML = 
                    '<div class="empty-state">' +
                    '<div class="empty-state-icon">📅</div>' +
                    '<div class="empty-state-text">Нет событий для этого дня</div>' +
                    '</div>';
                return;
            }
            
            // Сортируем события по времени
            var sortedEvents = dayData.events.slice().sort(function(a, b) {
                return a.ts.localeCompare(b.ts);
            });
            
            sortedEvents.forEach(function(event) {
                var item = document.createElement('div');
                item.className = 'timeline-item';
                
                var time = document.createElement('div');
                time.className = 'timeline-time';
                time.textContent = formatTime(event.ts);
                
                var content = document.createElement('div');
                content.className = 'timeline-content';
                
                var title = document.createElement('div');
                title.className = 'timeline-title';
                title.textContent = event.title;
                
                var desc = document.createElement('div');
                desc.className = 'timeline-desc';
                desc.textContent = event.desc || '';
                
                var meta = document.createElement('div');
                meta.className = 'timeline-meta';
                
                if (event.kind === 'meal') {
                    if (event.kcal) {
                        var kcalBadge = document.createElement('span');
                        kcalBadge.className = 'meta-badge accent';
                        kcalBadge.textContent = event.kcal + ' ккал';
                        meta.appendChild(kcalBadge);
                    }
                    
                    if (event.p) {
                        var proteinBadge = document.createElement('span');
                        proteinBadge.className = 'meta-badge';
                        proteinBadge.textContent = 'Б: ' + event.p + 'г';
                        meta.appendChild(proteinBadge);
                    }
                    
                    if (event.f) {
                        var fatBadge = document.createElement('span');
                        fatBadge.className = 'meta-badge';
                        fatBadge.textContent = 'Ж: ' + event.f + 'г';
                        meta.appendChild(fatBadge);
                    }
                    
                    if (event.c) {
                        var carbBadge = document.createElement('span');
                        carbBadge.className = 'meta-badge';
                        carbBadge.textContent = 'У: ' + event.c + 'г';
                        meta.appendChild(carbBadge);
                    }
                } else if (event.kind === 'workout') {
                    if (event.lift) {
                        var liftBadge = document.createElement('span');
                        liftBadge.className = 'meta-badge success';
                        var liftNames = {
                            'bench': 'Жим лёжа',
                            'squat': 'Присед',
                            'deadlift': 'Тяга',
                            'ohp': 'Армейский жим'
                        };
                        liftBadge.textContent = liftNames[event.lift] || event.lift;
                        meta.appendChild(liftBadge);
                    }
                    
                    if (event.e1rm) {
                        var e1rmBadge = document.createElement('span');
                        e1rmBadge.className = 'meta-badge warning';
                        e1rmBadge.textContent = 'e1RM: ' + event.e1rm + ' кг';
                        meta.appendChild(e1rmBadge);
                    }
                    
                    if (event.volume) {
                        var volumeBadge = document.createElement('span');
                        volumeBadge.className = 'meta-badge';
                        volumeBadge.textContent = 'Объем: ' + event.volume + ' кг';
                        meta.appendChild(volumeBadge);
                    }
                    
                    if (event.sets && event.sets.length > 0) {
                        var setsBadge = document.createElement('span');
                        setsBadge.className = 'meta-badge';
                        var setsText = event.sets.map(function(s) {
                            return s.w + 'x' + s.r;
                        }).join(', ');
                        setsBadge.textContent = setsText;
                        meta.appendChild(setsBadge);
                    }
                } else if (event.kind === 'metric') {
                    if (event.weight) {
                        var weightBadge = document.createElement('span');
                        weightBadge.className = 'meta-badge';
                        weightBadge.textContent = 'Вес: ' + event.weight + ' кг';
                        meta.appendChild(weightBadge);
                    }
                    
                    if (event.waist) {
                        var waistBadge = document.createElement('span');
                        waistBadge.className = 'meta-badge';
                        waistBadge.textContent = 'Талия: ' + event.waist + ' см';
                        meta.appendChild(waistBadge);
                    }
                    
                    if (event.steps) {
                        var stepsBadge = document.createElement('span');
                        stepsBadge.className = 'meta-badge';
                        stepsBadge.textContent = 'Шаги: ' + event.steps;
                        meta.appendChild(stepsBadge);
                    }
                    
                    if (event.sleep_hours) {
                        var sleepBadge = document.createElement('span');
                        sleepBadge.className = 'meta-badge';
                        sleepBadge.textContent = 'Сон: ' + event.sleep_hours + ' ч';
                        meta.appendChild(sleepBadge);
                    }
                }
                
                content.appendChild(title);
                if (desc.textContent) content.appendChild(desc);
                if (meta.children.length > 0) content.appendChild(meta);
                
                item.appendChild(time);
                item.appendChild(content);
                
                container.appendChild(item);
            });
        }
        
        // Рендер аналитики - Сводка
        function renderSummary() {
            renderCoachSummary();
            renderStrengthCards();
            renderAnalyticsCards();
            renderTrainerNotes();
            renderNutritionistNotesSummary();
        }
        
        // Рендер сводки тренера
        function renderCoachSummary() {
            var container = document.getElementById('coach-text');
            if (!container) return;
            
            var today = new Date();
            var todayData = getDataForDate(today);
            
            var html = '<div class="coach-text">';
            html += 'Дата: <span class="coach-highlight">' + 
                today.toLocaleDateString('ru', { 
                    weekday: 'long', 
                    year: 'numeric', 
                    month: 'long', 
                    day: 'numeric' 
                }) + '</span><br>';
            
            if (todayData && todayData.totals) {
                var targetKcal = 2200; // Примерная цель
                var diff = targetKcal - todayData.totals.kcal;
                
                html += 'Питание: <span class="coach-highlight">' + 
                    todayData.totals.kcal + ' ккал</span> из цели ~' + targetKcal + ' ккал<br>';
                
                if (diff > 0) {
                    html += 'Осталось: <span class="coach-highlight">' + diff + ' ккал</span><br>';
                } else {
                    html += 'Перебор: <span class="coach-highlight">' + Math.abs(diff) + ' ккал</span><br>';
                }
            }
            
            // Поиск последнего жима
            var benchE1RM = 0;
            for (var i = DATA.length - 1; i >= 0; i--) {
                if (DATA[i].events) {
                    for (var j = 0; j < DATA[i].events.length; j++) {
                        var event = DATA[i].events[j];
                        if (event.kind === 'workout' && event.lift === 'bench' && event.e1rm) {
                            benchE1RM = event.e1rm;
                            break;
                        }
                    }
                }
                if (benchE1RM > 0) break;
            }
            
            if (benchE1RM > 0) {
                var benchGoal = 100;
                var benchDiff = benchGoal - benchE1RM;
                html += 'Жим лёжа e1RM: <span class="coach-highlight">' + benchE1RM + ' кг</span><br>';
                html += 'До цели ' + benchGoal + ' кг осталось: <span class="coach-highlight">' + 
                    benchDiff + ' кг</span><br>';
            } else {
                html += '<span class="coach-highlight">Проведите ТЕСТ ЖИМ для оценки силы</span><br>';
            }
            
            html += '<br>Общий фокус:<br>';
            html += '• Дефицит калорий 10-15% для снижения жира<br>';
            html += '• Шаги ≥8000-10000 в день<br>';
            html += '• Сон 7-8 часов<br>';
            html += '• Специализация на жиме лёжа по системе 2019-2020';
            
            html += '</div>';
            container.innerHTML = html;
        }
        
        // Рендер карточек силовых показателей
        function renderStrengthCards() {
            var container = document.getElementById('strength-cards');
            if (!container) return;
            
            container.innerHTML = '';
            
            var lifts = [
                { key: 'bench', name: 'Жим лёжа', target: 100 },
                { key: 'squat', name: 'Присед', target: 120 },
                { key: 'deadlift', name: 'Тяга', target: 140 },
                { key: 'ohp', name: 'Армейский', target: 60 }
            ];
            
            var e1rms = {};
            
            // Поиск лучших e1RM
            DATA.forEach(function(day) {
                if (day.events) {
                    day.events.forEach(function(event) {
                        if (event.kind === 'workout' && event.lift && event.e1rm) {
                            if (!e1rms[event.lift] || event.e1rm > e1rms[event.lift]) {
                                e1rms[event.lift] = event.e1rm;
                            }
                        }
                    });
                }
            });
            
            lifts.forEach(function(lift) {
                var card = document.createElement('div');
                card.className = 'strength-card';
                
                var value = e1rms[lift.key] || 0;
                
                card.innerHTML = 
                    '<div class="strength-label">' + lift.name + '</div>' +
                    '<div class="strength-value">' + (value || '—') + '</div>' +
                    '<div class="strength-unit">кг</div>';
                
                container.appendChild(card);
            });
            
            // Карточка суммы SBD
            if (e1rms.bench && e1rms.squat && e1rms.deadlift) {
                var sbdCard = document.createElement('div');
                sbdCard.className = 'strength-card';
                sbdCard.style.gridColumn = 'span 2';
                
                var sbdTotal = e1rms.bench + e1rms.squat + e1rms.deadlift;
                
                sbdCard.innerHTML = 
                    '<div class="strength-label">Сумма SBD</div>' +
                    '<div class="strength-value">' + sbdTotal + '</div>' +
                    '<div class="strength-unit">кг</div>';
                
                container.appendChild(sbdCard);
            }
        }
        
        // Рендер карточек аналитики
        function renderAnalyticsCards() {
            var container = document.getElementById('analytics-cards');
            if (!container) return;
            
            container.innerHTML = '';
            
            // Расчет метрик за период
            var periodData = getPeriodData();
            
            // Карточка питания
            var nutritionCard = document.createElement('div');
            nutritionCard.className = 'analytics-card';
            nutritionCard.innerHTML = 
                '<div class="card-title">Питание</div>' +
                '<div class="card-value">' + periodData.totalKcal + '</div>' +
                '<div class="card-subtitle">ккал за период</div>' +
                '<div style="margin-top: 12px;">' +
                '<div>Среднее в день: ' + periodData.avgKcal + ' ккал</div>' +
                '<div>Белки: ' + periodData.avgProtein + 'г | Жиры: ' + periodData.avgFat + 'г | Углеводы: ' + periodData.avgCarbs + 'г</div>' +
                '</div>';
            container.appendChild(nutritionCard);
            
            // Карточка дефицита/профицита
            var deficitCard = document.createElement('div');
            deficitCard.className = 'analytics-card';
            var targetKcal = 2200;
            var avgDeficit = targetKcal - periodData.avgKcal;
            var deficitText = avgDeficit > 0 ? 'Дефицит' : 'Профицит';
            deficitCard.innerHTML = 
                '<div class="card-title">' + deficitText + '</div>' +
                '<div class="card-value">' + Math.abs(avgDeficit) + '</div>' +
                '<div class="card-subtitle">ккал в день</div>';
            container.appendChild(deficitCard);
            
            // Карточка тренировок
            var workoutCard = document.createElement('div');
            workoutCard.className = 'analytics-card';
            workoutCard.innerHTML = 
                '<div class="card-title">Тренировки</div>' +
                '<div class="card-value">' + periodData.workouts + '</div>' +
                '<div class="card-subtitle">сессий за период</div>' +
                '<div style="margin-top: 12px;">Общий объем: ' + periodData.totalVolume + ' кг</div>';
            container.appendChild(workoutCard);
            
            // Карточка веса и талии
            if (periodData.lastWeight || periodData.lastWaist) {
                var bodyCard = document.createElement('div');
                bodyCard.className = 'analytics-card';
                bodyCard.innerHTML = 
                    '<div class="card-title">Вес и талия</div>' +
                    '<div class="card-value">' + (periodData.lastWeight || '—') + ' кг</div>' +
                    '<div class="card-subtitle">Талия: ' + (periodData.lastWaist || '—') + ' см</div>';
                container.appendChild(bodyCard);
            }
        }
        
        // Получение данных за период
        function getPeriodData() {
            var result = {
                totalKcal: 0,
                avgKcal: 0,
                avgProtein: 0,
                avgFat: 0,
                avgCarbs: 0,
                workouts: 0,
                totalVolume: 0,
                lastWeight: null,
                lastWaist: null,
                days: 0
            };
            
            var refDate = document.getElementById('reference-date');
            var endDate = refDate && refDate.value ? new Date(refDate.value) : new Date();
            var startDate = new Date(endDate);
            
            var periodSelect = document.getElementById('period-selector');
            var period = periodSelect ? periodSelect.value : 'week';
            
            switch (period) {
                case 'day':
                    startDate.setDate(startDate.getDate() - 1);
                    break;
                case 'week':
                    startDate.setDate(startDate.getDate() - 7);
                    break;
                case 'month':
                    startDate.setMonth(startDate.getMonth() - 1);
                    break;
                case 'quarter':
                    startDate.setMonth(startDate.getMonth() - 3);
                    break;
                case 'half':
                    startDate.setMonth(startDate.getMonth() - 6);
                    break;
                case 'year':
                    startDate.setFullYear(startDate.getFullYear() - 1);
                    break;
                case 'all':
                    startDate = new Date('2019-01-01');
                    break;
            }
            
            var totalP = 0, totalF = 0, totalC = 0;
            
            DATA.forEach(function(day) {
                var dayDate = new Date(day.date);
                if (dayDate >= startDate && dayDate <= endDate) {
                    result.days++;
                    
                    if (day.totals) {
                        result.totalKcal += day.totals.kcal || 0;
                        totalP += day.totals.p || 0;
                        totalF += day.totals.f || 0;
                        totalC += day.totals.c || 0;
                    }
                    
                    if (day.weight) {
                        result.lastWeight = day.weight;
                    }
                    
                    if (day.waist) {
                        result.lastWaist = day.waist;
                    }
                    
                    if (day.events) {
                        day.events.forEach(function(event) {
                            if (event.kind === 'workout') {
                                result.workouts++;
                                result.totalVolume += event.volume || 0;
                            }
                            
                            if (event.kind === 'metric') {
                                if (event.weight) result.lastWeight = event.weight;
                                if (event.waist) result.lastWaist = event.waist;
                            }
                        });
                    }
                }
            });
            
            if (result.days > 0) {
                result.avgKcal = Math.round(result.totalKcal / result.days);
                result.avgProtein = Math.round(totalP / result.days);
                result.avgFat = Math.round(totalF / result.days);
                result.avgCarbs = Math.round(totalC / result.days);
            }
            
            return result;
        }
        
        // Рендер питания и целей
        function renderNutrition() {
            renderNutritionCalculations();
            renderNutritionistNotes();
            updateBenchProgress();
        }
        
        // Рендер расчетов питания
        function renderNutritionCalculations() {
            var container = document.getElementById('nutrition-calculations');
            if (!container) return;
            
            container.innerHTML = '';
            
            // Получаем последний вес
            var currentWeight = 0;
            for (var i = DATA.length - 1; i >= 0; i--) {
                if (DATA[i].weight) {
                    currentWeight = DATA[i].weight;
                    break;
                }
                if (DATA[i].events) {
                    for (var j = DATA[i].events.length - 1; j >= 0; j--) {
                        if (DATA[i].events[j].weight) {
                            currentWeight = DATA[i].events[j].weight;
                            break;
                        }
                    }
                }
                if (currentWeight > 0) break;
            }
            
            if (currentWeight === 0) {
                container.innerHTML = '<div style="color: var(--warning);">Нужен утренний вес для расчета</div>';
                return;
            }
            
            // Расчет по формуле Mifflin-St Jeor
            var height = 192;
            var age = 32;
            var bmr = 10 * currentWeight + 6.25 * height - 5 * age + 5;
            var tdee = Math.round(bmr * 1.55); // Умеренная активность
            var targetKcal = Math.round(tdee * 0.88); // 12% дефицит
            var targetProtein = Math.round(currentWeight * 1.8);
            var targetFat = Math.round(currentWeight * 0.8);
            var targetCarbs = Math.round((targetKcal - (targetProtein * 4 + targetFat * 9)) / 4);
            
            var goals = [
                { label: 'Текущий вес', value: currentWeight + ' кг' },
                { label: 'BMR (базовый метаболизм)', value: Math.round(bmr) + ' ккал' },
                { label: 'TDEE (с активностью)', value: tdee + ' ккал' },
                { label: 'Целевые калории (дефицит 12%)', value: targetKcal + ' ккал' },
                { label: 'Белки', value: targetProtein + ' г (' + (targetProtein * 4) + ' ккал)' },
                { label: 'Жиры', value: targetFat + ' г (' + (targetFat * 9) + ' ккал)' },
                { label: 'Углеводы', value: targetCarbs + ' г (' + (targetCarbs * 4) + ' ккал)' }
            ];
            
            goals.forEach(function(goal) {
                var item = document.createElement('div');
                item.className = 'goal-item';
                item.innerHTML = 
                    '<div class="goal-label">' + goal.label + '</div>' +
                    '<div class="goal-value">' + goal.value + '</div>';
                container.appendChild(item);
            });
        }
        
        // Рендер заметок нутрициолога
        function renderNutritionistNotes() {
            var container = document.getElementById('nutritionist-notes');
            if (!container) return;
            
            container.innerHTML = '';
            
            var periodData = getPeriodData();
            var notes = [];
            
            // Анализ белка
            if (periodData.avgProtein > 0) {
                var targetProtein = 165; // ~1.8г/кг для 92кг
                if (periodData.avgProtein < targetProtein * 0.9) {
                    notes.push('⚠️ Белка маловато: ' + periodData.avgProtein + 'г в день. Цель ~' + targetProtein + 'г');
                } else if (periodData.avgProtein > targetProtein * 1.1) {
                    notes.push('✓ Белка достаточно: ' + periodData.avgProtein + 'г в день');
                } else {
                    notes.push('✓ Белок в норме: ' + periodData.avgProtein + 'г в день');
                }
            }
            
            // Анализ жиров
            if (periodData.avgFat > 0) {
                var targetFatMin = 55; // 0.6г/кг
                var targetFatMax = 83; // 0.9г/кг
                if (periodData.avgFat < targetFatMin) {
                    notes.push('⚠️ Жиров мало: ' + periodData.avgFat + 'г. Минимум ' + targetFatMin + 'г');
                } else if (periodData.avgFat > targetFatMax) {
                    notes.push('⚠️ Жиров многовато: ' + periodData.avgFat + 'г. Максимум ' + targetFatMax + 'г');
                } else {
                    notes.push('✓ Жиры в норме: ' + periodData.avgFat + 'г в день');
                }
            }
            
            // Анализ калорий
            if (periodData.avgKcal > 0) {
                var targetKcal = 2200;
                var diff = Math.abs(periodData.avgKcal - targetKcal);
                if (diff <= 200) {
                    notes.push('✓ Калории близки к цели: ' + periodData.avgKcal + ' ккал');
                } else if (periodData.avgKcal < targetKcal) {
                    notes.push('⚠️ Недоедание: -' + diff + ' ккал от цели');
                } else {
                    notes.push('⚠️ Переедание: +' + diff + ' ккал от цели');
                }
            }
            
            // Подсказки
            notes.push('💡 Перед тяжелым жимом: быстрые углеводы за 60-90 минут');
            notes.push('💡 После тренировки: белок + углеводы в течение 30 минут');
            notes.push('💡 Голодание в воскресенье: отличная практика для метаболизма');
            
            notes.forEach(function(note) {
                var div = document.createElement('div');
                div.style.marginBottom = '12px';
                div.style.lineHeight = '1.6';
                div.innerHTML = note;
                container.appendChild(div);
            });
        }
        
        // Обновление прогресса жима
        function updateBenchProgress() {
            var bar = document.getElementById('bench-progress');
            if (!bar) return;
            
            var currentBench = 0;
            for (var i = DATA.length - 1; i >= 0; i--) {
                if (DATA[i].events) {
                    for (var j = 0; j < DATA[i].events.length; j++) {
                        var event = DATA[i].events[j];
                        if (event.kind === 'workout' && event.lift === 'bench' && event.e1rm) {
                            currentBench = event.e1rm;
                            break;
                        }
                    }
                }
                if (currentBench > 0) break;
            }
            
            var progress = Math.min((currentBench / 100) * 100, 100);
            bar.style.width = progress + '%';
        }
        
        // Обновление label даты
        function updateDateLabel() {
            var label = document.getElementById('date-label');
            if (!label) return;
            
            label.textContent = selectedDate.toLocaleDateString('ru', { 
                month: 'long', 
                year: 'numeric' 
            });
        }
        
        // Навигация по датам
        function navigateDate(direction) {
            selectedDate.setMonth(selectedDate.getMonth() + direction);
            
            updateDateLabel();
            renderCalendar();
            renderTimeline();
        }
        
        // Экспорт в JSON
        function exportJSON() {
            var dataStr = JSON.stringify(DATA, null, 2);
            var dataBlob = new Blob([dataStr], { type: 'application/json' });
            var url = URL.createObjectURL(dataBlob);
            var link = document.createElement('a');
            link.href = url;
            link.download = 'training_diary_' + formatDate(new Date()) + '.json';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(url);
        }
        
        // Экспорт в CSV
        function exportCSV() {
            var csv = 'Date,Time,Kind,Title,Description,Kcal,Protein,Fat,Carbs,Volume,e1RM\n';
            
            DATA.forEach(function(day) {
                if (day.events) {
                    day.events.forEach(function(event) {
                        var row = [
                            day.date,
                            formatTime(event.ts),
                            event.kind,
                            '"' + (event.title || '').replace(/"/g, '""') + '"',
                            '"' + (event.desc || '').replace(/"/g, '""') + '"',
                            event.kcal || '',
                            event.p || '',
                            event.f || '',
                            event.c || '',
                            event.volume || '',
                            event.e1rm || ''
                        ];
                        csv += row.join(',') + '\n';
                    });
                }
            });
            
            var csvBlob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
            var url = URL.createObjectURL(csvBlob);
            var link = document.createElement('a');
            link.href = url;
            link.download = 'training_diary_' + formatDate(new Date()) + '.csv';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(url);
        }
        
        // Привязка обработчиков событий
        function attachListeners() {
            // Главные вкладки
            var tabButtons = document.querySelectorAll('.app-header .segment-control button');
            for (var i = 0; i < tabButtons.length; i++) {
                tabButtons[i].addEventListener('click', function() {
                    var tab = this.dataset.tab;
                    
                    // Активация кнопки
                    var siblings = this.parentElement.querySelectorAll('button');
                    for (var j = 0; j < siblings.length; j++) {
                        siblings[j].classList.remove('active');
                    }
                    this.classList.add('active');
                    
                    // Показ вкладки
                    var tabs = document.querySelectorAll('.main-content > .tab-content');
                    for (var k = 0; k < tabs.length; k++) {
                        tabs[k].classList.remove('active');
                    }
                    
                    var targetTab = document.getElementById(tab + '-tab');
                    if (targetTab) {
                        targetTab.classList.add('active');
                        currentTab = tab;
                        
                        if (tab === 'analytics') {
                            renderSummary();
                        }
                    }
                });
            }
            
            // Переключатель видов календаря - удален
            
            // Навигация по датам
            var prevButton = document.getElementById('prev-button');
            if (prevButton) {
                prevButton.addEventListener('click', function() {
                    navigateDate(-1);
                });
            }
            
            var nextButton = document.getElementById('next-button');
            if (nextButton) {
                nextButton.addEventListener('click', function() {
                    navigateDate(1);
                });
            }
            
            // Экспорт
            var exportJsonButton = document.getElementById('export-json');
            if (exportJsonButton) {
                exportJsonButton.addEventListener('click', exportJSON);
            }
            
            var exportCsvButton = document.getElementById('export-csv');
            if (exportCsvButton) {
                exportCsvButton.addEventListener('click', exportCSV);
            }
            
            // Под-вкладки аналитики
            var analyticsButtons = document.querySelectorAll('#analytics-tab .segment-control button');
            for (var i = 0; i < analyticsButtons.length; i++) {
                analyticsButtons[i].addEventListener('click', function() {
                    var analyticsTab = this.dataset.analytics;
                    if (analyticsTab) {
                        currentAnalyticsTab = analyticsTab;
                        
                        // Активация кнопки
                        var siblings = this.parentElement.querySelectorAll('button');
                        for (var j = 0; j < siblings.length; j++) {
                            siblings[j].classList.remove('active');
                        }
                        this.classList.add('active');
                        
                        // Показ под-вкладки
                        var summaryContent = document.getElementById('summary-content');
                        var nutritionContent = document.getElementById('nutrition-content');
                        
                        if (analyticsTab === 'summary') {
                            if (summaryContent) summaryContent.classList.add('active');
                            if (nutritionContent) nutritionContent.classList.remove('active');
                            renderSummary();
                        } else {
                            if (summaryContent) summaryContent.classList.remove('active');
                            if (nutritionContent) nutritionContent.classList.add('active');
                            renderNutrition();
                        }
                    }
                });
            }
            
            // Селектор периода
            var periodSelector = document.getElementById('period-selector');
            if (periodSelector) {
                periodSelector.addEventListener('change', function() {
                    referencePeriod = this.value;
                    updatePeriodLabel();
                    if (currentAnalyticsTab === 'summary') {
                        renderSummary();
                    } else {
                        renderNutrition();
                    }
                });
            }
            
            // Дата-пикер
            var referenceDatePicker = document.getElementById('reference-date');
            if (referenceDatePicker) {
                referenceDatePicker.value = formatDate(new Date());
                referenceDatePicker.addEventListener('change', function() {
                    updatePeriodLabel();
                    if (currentAnalyticsTab === 'summary') {
                        renderSummary();
                    } else {
                        renderNutrition();
                    }
                });
            }
        }
        
        // Обновление label периода
        function updatePeriodLabel() {
            var label = document.getElementById('period-label');
            if (!label) return;
            
            var refDate = document.getElementById('reference-date');
            var endDate = refDate && refDate.value ? new Date(refDate.value) : new Date();
            var startDate = new Date(endDate);
            
            var periodSelect = document.getElementById('period-selector');
            var period = periodSelect ? periodSelect.value : 'week';
            
            switch (period) {
                case 'day':
                    startDate.setDate(startDate.getDate() - 1);
                    break;
                case 'week':
                    startDate.setDate(startDate.getDate() - 7);
                    break;
                case 'month':
                    startDate.setMonth(startDate.getMonth() - 1);
                    break;
                case 'quarter':
                    startDate.setMonth(startDate.getMonth() - 3);
                    break;
                case 'half':
                    startDate.setMonth(startDate.getMonth() - 6);
                    break;
                case 'year':
                    startDate.setFullYear(startDate.getFullYear() - 1);
                    break;
                case 'all':
                    startDate = new Date('2019-01-01');
                    break;
            }
            
            var days = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
            
            label.textContent = startDate.toLocaleDateString('ru', { day: '2-digit', month: '2-digit', year: 'numeric' }) +
                ' — ' + endDate.toLocaleDateString('ru', { day: '2-digit', month: '2-digit', year: 'numeric' }) +
                ' (' + days + ' дн.)';
        }
        
        // Инициализация
        function init() {
            initData();
            attachListeners();
            updateDateLabel();
            renderCalendar();
            renderDaysList();
            renderTimeline();
            updatePeriodLabel();
        }
        
        // Запуск после загрузки DOM
        document.addEventListener('DOMContentLoaded', init);
    })();
    </script>
</body>
</html>
