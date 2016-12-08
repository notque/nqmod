-- Created by HellBlazer 02/11/16

-- Update turn timers to stop later game timers being so long
UPDATE TurnSegments SET TimeLimit_PerCity='6' WHERE TimeLimit_PerCity='10';
UPDATE TurnSegments SET TimeLimit_PerUnit='4' WHERE TimeLimit_PerUnit='5';