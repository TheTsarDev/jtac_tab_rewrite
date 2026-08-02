//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

	_display = uiNamespace getVariable "TOG_jtac_trans_dlg";
	_sequrityList = _display displayCtrl 1008;
	_size = lbSize _sequrityList;
	_selectedSeqrity = lbCurSel _sequrityList;
	_transSequrity = _sequrityList lbValue _selectedSeqrity;

	TOG_jtac_Trans_sequrity = _transSequrity;