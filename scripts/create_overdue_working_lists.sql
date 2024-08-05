INSERT INTO programstageworkinglist (
    programstageworkinglistid, uid, code, created, createdby, lastupdated, 
    lastupdatedby, name, description, programid, programstageid, 
    programstagequerycriteria, translations, sharing, userid
) VALUES (
    1, 'KkcUsY8F5tK', 'NCD_HTN_AGREED_TO_VISIT', NOW(), 1, NOW(), 
    1, 'Overdue - 2. Agreed to visit', '', 
    (SELECT programid FROM program WHERE uid = 'pMIglSEqPGS'), 
    (SELECT programstageid FROM programstage WHERE uid = 'W7BCOaSquMd'), 
    '{"order": "createdAt:desc", "dataFilters": [{"in": ["AGREE_TO_VISIT"], "dataItem": "q362A7evMYt"}], "assignedUsers": [], "eventOccurredAt": {"type": "RELATIVE", "endBuffer": 0, "startBuffer": -60}, "displayColumnOrder": ["sB1IHYu2xQT", "ENRjVGxVL6l", "oindugucx72", "NI0QRzJvQ0k", "YRDy9xy9jD0", "jCRIT4GMMOS", "fI1P3Mg1zOZ"], "attributeValueFilters": [{"in": ["ACTIVE"], "attribute": "fI1P3Mg1zOZ"}, {"in": ["YES"], "attribute": "jCRIT4GMMOS"}]}', 
    '[]', '{"owner": "M5zQapPyTZI", "users": {}, "public": "r-------", "external": false, "userGroups": {}}', 
    1
);

INSERT INTO programstageworkinglist (
    programstageworkinglistid, uid, code, created, createdby, lastupdated, 
    lastupdatedby, name, description, programid, programstageid, 
    programstagequerycriteria, translations, sharing, userid
) VALUES (
    2, 'E1eBXuCAXUU', 'NCD_HTN_REMOVE_FROM_LIST', NOW(), 1, NOW(), 
    1, 'Overdue - 4. Remove from list', '', 
    (SELECT programid FROM program WHERE uid = 'pMIglSEqPGS'), 
    (SELECT programstageid FROM programstage WHERE uid = 'W7BCOaSquMd'), 
    '{"order": "createdAt:desc", "dataFilters": [{"in": ["REMOVE_FROM_OVERDUE"], "dataItem": "q362A7evMYt"}], "assignedUsers": [], "displayColumnOrder": ["sB1IHYu2xQT", "ENRjVGxVL6l", "oindugucx72", "NI0QRzJvQ0k", "YRDy9xy9jD0", "jCRIT4GMMOS", "fI1P3Mg1zOZ"], "attributeValueFilters": [{"in": ["YES"], "attribute": "jCRIT4GMMOS"}, {"in": ["ACTIVE"], "attribute": "fI1P3Mg1zOZ"}]}', 
    '[]', '{"owner": "M5zQapPyTZI", "users": {}, "public": "r-------", "external": false, "userGroups": {}}', 
    1
);

INSERT INTO programstageworkinglist (
    programstageworkinglistid, uid, code, created, createdby, lastupdated, 
    lastupdatedby, name, description, programid, programstageid, 
    programstagequerycriteria, translations, sharing, userid
) VALUES (
    3, 'g7YeCCkyj0N', 'NCD_HTN_REMIND_TO_CALL', NOW(), 1, NOW(), 
    1, 'Overdue - 3. Remind to call later', '', 
    (SELECT programid FROM program WHERE uid = 'pMIglSEqPGS'), 
    (SELECT programstageid FROM programstage WHERE uid = 'W7BCOaSquMd'), 
    '{"order": "createdAt:desc", "dataFilters": [{"in": ["REMIND_TO_CALL_LATER"], "dataItem": "q362A7evMYt"}], "assignedUsers": [], "eventOccurredAt": {"type": "RELATIVE", "endBuffer": 0, "startBuffer": -60}, "displayColumnOrder": ["sB1IHYu2xQT", "ENRjVGxVL6l", "oindugucx72", "NI0QRzJvQ0k", "YRDy9xy9jD0", "jCRIT4GMMOS", "fI1P3Mg1zOZ"], "attributeValueFilters": [{"in": ["ACTIVE"], "attribute": "fI1P3Mg1zOZ"}, {"in": ["YES"], "attribute": "jCRIT4GMMOS"}]}', 
    '[]', '{"owner": "M5zQapPyTZI", "users": {}, "public": "r-------", "external": false, "userGroups": {}}', 
    1
);

INSERT INTO programstageworkinglist (
    programstageworkinglistid, uid, code, created, createdby, lastupdated, 
    lastupdatedby, name, description, programid, programstageid, 
    programstagequerycriteria, translations, sharing, userid
) VALUES (
    4, 'IVpnpOgBdBq', '', NOW(), 1, NOW(), 
    1, 'Overdue patients', '', 
    (SELECT programid FROM program WHERE uid = 'pMIglSEqPGS'), 
    (SELECT programstageid FROM programstage WHERE uid = 'anb2cjLx3WM'), 
    '{"order": "createdAt:desc", "dataFilters": [], "eventStatus": "OVERDUE", "assignedUsers": [], "displayColumnOrder": ["sB1IHYu2xQT", "ENRjVGxVL6l", "oindugucx72", "NI0QRzJvQ0k", "YRDy9xy9jD0", "status", "scheduledAt", "createdAt", "jCRIT4GMMOS", "fI1P3Mg1zOZ"], "attributeValueFilters": []}', 
    '[]', '{"owner": "M5zQapPyTZI", "users": {}, "public": "--------", "external": false, "userGroups": {}}', 
    1
);

INSERT INTO programstageworkinglist (
    programstageworkinglistid, uid, code, created, createdby, lastupdated, 
    lastupdatedby, name, description, programid, programstageid, 
    programstagequerycriteria, translations, sharing, userid
) VALUES (
    5, 'UJ6ohaQ4S5X', 'NCD_HTN_PENDING_TO_CALL', NOW(), 1, NOW(), 
    1, 'Overdue - 1. Pending to call', '', 
    (SELECT programid FROM program WHERE uid = 'pMIglSEqPGS'), 
    (SELECT programstageid FROM programstage WHERE uid = 'anb2cjLx3WM'), 
    '{"order": "createdAt:desc", "dataFilters": [], "assignedUsers": [], "eventOccurredAt": {"type": "RELATIVE", "endBuffer": 0, "startBuffer": -60}, "displayColumnOrder": ["sB1IHYu2xQT", "ENRjVGxVL6l", "YRDy9xy9jD0", "oindugucx72", "NI0QRzJvQ0k", "scheduledAt"], "attributeValueFilters": [{"in": ["OVERDUE_PENDING_CALL"], "attribute": "rgeuEnAI0nj"}, {"in": ["YES"], "attribute": "jCRIT4GMMOS"}, {"in": ["ACTIVE"], "attribute": "fI1P3Mg1zOZ"}]}', 
    '[]', '{"owner": "M5zQapPyTZI", "users": {}, "public": "r-------", "external": false, "userGroups": {"qSSuhs65xMP": {"id": "qSSuhs65xMP", "access": "r-------"}}}', 
    1
);
