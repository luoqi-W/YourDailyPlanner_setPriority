%% 
% In our daily lives, we tend to have a bunch of to-do and pile them
% up because we don't know which to start. It's so hard to decide! We have
% something we don't want to do but have to. The to do might be something
% so closed to the deadline; The to do also could be something that's so
% complex to finish! And our energy level changes all the time.
% By thinking about these, we tend to procrastinate to start doing the
% things, trying to escape from them.

% The reason why I choose 6 things to enter here is because, I ever read a
% book. In the book, I learnt that completing six tasks in a day is
% achievable with high efficiency and focus, and generally, completing six
% tasks at a high quality in a day is quite impressive.

% This is a mini-project that builds a simple daily planner that ranks six
% tasks you want to do today, based on difficulty, emergency,
% willingness, and your current energy level. This program helps users
% overcome procrastination by ranking six tasks using a simple
% weighted scoring system inside a GUI-based planner.


% construct a 4×6 cell: 4 properties × 6 to do
userTop6Cell = cell(4, 6);


% GUI: prompt & userinput
for ii = 1:6
    promptCell = { ...
        'Enter one thing you want to do today:' , ...
        'Is it hard to do? (rank 1–5)', ...
        'Is it urgent? (rank 1–5)', ...
        'Do you want to do it? (rank 1–5)'};
    
    titleBox = ['Top 6 To-Do TODAY (Item ', num2str(ii), ' of 6)'];
    userInput = inputdlg(promptCell, titleBox, [1 60]);
    
    if isempty(userInput)
        disp('Failed to process.');
        return;
    end
    
    userTop6Cell(:, ii) = userInput;
end


%weights
emergency_weight = 3;
willingness_weight = 2;

% Ask user for current energy state to decide difficulty_weight
energyChoice = menu('How do you feel today?','Energetic','Tired'); 

if energyChoice == 1
    difficulty_weight = -1;
else
    difficulty_weight = -5; 
end


% convert to 6×4，and then convert to structure
userTop6Cell_T = userTop6Cell.';   
a = {'things','difficulty','emergency','willingness'};
userTop6Struct = cell2struct(userTop6Cell_T, a, 2);


% str to double & calculate the scores
item_scores = zeros(6, 1);

for jj = 1:6
    difficulty  = str2double(userTop6Struct(jj).difficulty);
    emergency   = str2double(userTop6Struct(jj).emergency);
    willingness = str2double(userTop6Struct(jj).willingness);
    item_scores(jj) = difficulty*difficulty_weight + emergency*emergency_weight + willingness* willingness_weight;
end


% sort by the scores
[sorted_scores, sortIndex] = sort(item_scores, 'descend');
priorityStruct = userTop6Struct(sortIndex);


%output
text = sprintf('Today''s To-Do List\n============================\n');

for kk = 1:6
    item  = priorityStruct(kk);
    score = sorted_scores(kk);
    
    line1 = sprintf('Priority %d (Score: %.2f): %s\n', ...
                    kk, score, item.things);
    line2 = sprintf('  - Difficulty: %s, Emergency: %s, Willingness: %s\n', ...
                    item.difficulty, item.emergency, item.willingness);
    text = [text, line1, line2];
    
end

finalText = [text, '===================================================='];

msgbox(finalText, 'After Ranking', 'help');
