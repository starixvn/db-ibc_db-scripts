Use bodb_ACC
GO 

---Select *from Acc_DWLList_xtest

DELETE Acc_DWLList WHERE Product IN ( 'Bingo', 'Poker', 'Poker (Due to Partners)')

DELETE Acc_DWLList_xtest WHERE Product IN ( 'Bingo', 'Poker', 'Poker (Due to Partners)')