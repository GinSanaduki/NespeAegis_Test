#!/usr/bin/gawk -f
# 3WayHandShake_FlowControl.awk
# gawk -f 3WayHandShake_FlowControl.awk
# https://www.infraexpert.com/study/tcpip11.html

BEGIN{
	Init();
	print "\033[36;1m<<<フロー制御の体験>>>\033[0m";
	print "多数の送信側ホストが同時にデータを送信して負荷が高まると";
	print "受信側はデータを処理しきれない場合が発生します。";
	print "このような場合、受信側はウィンドウサイズを小さくしその値を送り直します。";
	print "そして受信可能な状態になればウィンドウサイズを大きくして通知します。";
	Sleep_1();
	FlowControl();
	print "\033[36;1m<<<フロー制御の体験>>>　　　完\033[0m";
}

function Send_FromA_ToB_Action(Args_Mode, Local_OutText){
	if(Args_Mode == "IMMEDIATE"){
		print Send_FromA_ToB_ARROW_LAST;
		Sleep_1();
		return;
	}
	Local_OutText = CARRIAGE_RETURN Local_OutText Send_FromA_ToB_User_A;
	printf("%s", Local_OutText);
	Sleep_1();
	for(i = 1; i <= ArrowLen; i++){
		Local_OutText = CARRIAGE_RETURN Local_OutText Send_FromA_ToB_ARROW;
		printf("%s", Local_OutText);
		if(i % 4 == 0 && i < ArrowLen){
			Sleep_1();
		}
	}
	Local_OutText = CARRIAGE_RETURN Local_OutText Send_FromA_ToB_User_B;
	printf("%s", Local_OutText);
	print "";
	Sleep_1();
}

function Receive_FromB_ToA_Action(Args_Mode, Local_OutText, Local_Length, Local_Empty, Local_Arrow, Local_Empty_Length){
	if(Args_Mode == "IMMEDIATE"){
		print Receive_FromB_ToA_ARROW_LAST2;
		Sleep_1();
		return;
	}
	Local_Length = MAX_ARROW_LENGTH;
	for(i = 1; i <= Local_Length - 1; i++){
		Local_Empty = Local_Empty " ";
	}
	Local_OutText = CARRIAGE_RETURN Local_OutText Local_Empty Receive_FromB_ToA_User_B;
	printf("%s", Local_OutText);
	Sleep_1();
	Local_Length--;
	Local_Empty_Length = 72;
	for(i = 1; i <= ArrowLen; i++){
		Local_Empty = "";
		for(j = 1; j <= Local_Empty_Length - 1; j++){
			Local_Empty = Local_Empty " ";
		}
		Local_Arrow = "";
		for(j = 1; j <= i; j++){
			Local_Arrow = Local_Arrow Receive_FromB_ToA_ARROW;
		}
		Local_OutText = CARRIAGE_RETURN Local_Empty Local_Arrow Receive_FromB_ToA_User_B;
		printf("%s", Local_OutText);
		if(i % 4 == 0 && i < ArrowLen){
			Sleep_1();
		}
		Local_Length--;
		Local_Empty_Length = Local_Empty_Length - 4;
	}
	Local_Arrow = "";
	for(i = 1; i <= ArrowLen; i++){
		Local_Arrow = Local_Arrow Receive_FromB_ToA_ARROW;
	}
	Local_OutText = CARRIAGE_RETURN Receive_FromB_ToA_ARROW_LAST;
	printf("%s", Local_OutText);
	print "";
	Sleep_1();
}

function FlowControl(){
	print "・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・";
	Sleep_1();
	print MSG_ANNOTATION_WINDOWSIZE_3900;
	Sleep_1();
	print MSG_ANNOTATION_REPLY;
	Sleep_1();
	for(z = 1; z <= 2; z++){
		print MSG_DATA_SEND_1300_SLIDING_WINDOW;
		if(z == 1){
			Send_FromA_ToB_Action();
		} else {
			Send_FromA_ToB_Action("IMMEDIATE");
		}
		print MSG_COMPLETE_RECEIVE;
		if(z == 1){
			Receive_FromB_ToA_Action();
		} else {
			Receive_FromB_ToA_Action("IMMEDIATE");
		}
	}
	print MSG_ANNOTATION_STOP;
	Receive_FromB_ToA_Action("IMMEDIATE");
	print MSG_ANNOTATION_WINDOWSIZE_ZERO;
	Receive_FromB_ToA_Action("IMMEDIATE");
	for(i = 1; i <= 5; i++){
		print DESCRIPTIVE_PART_WAIT;
		Sleep_1();
	}
	print MSG_WINDOW_PROVE;
	Send_FromA_ToB_Action();
	print MSG_WINDOW_UPDATE;
	Receive_FromB_ToA_Action();
	for(z = 1; z <= 1; z++){
		print MSG_DATA_SEND_1300_SLIDING_WINDOW;
		Send_FromA_ToB_Action();
		print "・";
		Sleep_1();
		print "・";
		Sleep_1();
		print "・";
		Sleep_1();
	}
	print "・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・";
}

function Sleep_1(){
	system(CMD_SLEEP_1);
	close(CMD_SLEEP_1);
}

function Sleep_3(){
	system(CMD_SLEEP_3);
	close(CMD_SLEEP_3);
}

function Init(){
	LightBlue_Bold_Start = "\033[36;1m";
	LightPurple_Bold_Start = "\033[35;1m";
	Qualification_End = "\033[0m";
	# ---------------------------------------------------------------------
	CMD_SLEEP_1 = "sleep 1";
	CMD_SLEEP_3 = "sleep 3";
	ArrowLen = 18;
	# ---------------------------------------------------------------------
	MSG_DATA_SEND_1300_SLIDING_WINDOW = LightPurple_Bold_Start"A：ACKを待つことなく、データを1,300byte送るよ。"Qualification_End;
	MSG_COMPLETE_RECEIVE = LightBlue_Bold_Start"B：ACK（受け取った。）"Qualification_End;
	MSG_ANNOTATION_WINDOWSIZE_3900 = LightBlue_Bold_Start"B：ウインドウサイズは3,900！"Qualification_End;
	MSG_ANNOTATION_WINDOWSIZE_ZERO = LightBlue_Bold_Start"B：ウインドウサイズは0！"Qualification_End;
	MSG_ANNOTATION_REPLY = LightPurple_Bold_Start"A：通知してもらったウインドウサイズの分だけデータを送るよ。"Qualification_End;
	MSG_ANNOTATION_STOP = LightBlue_Bold_Start"B：あっ！バッファがいっぱいになったのでちょっと待って。"Qualification_End;
	MSG_WINDOW_PROVE = LightPurple_Bold_Start"A：ウィンドウプローブ（ウィンドウサイズの最新情報を教えて。）"Qualification_End;
	MSG_WINDOW_UPDATE = LightBlue_Bold_Start"B：ウインドウ更新通知（ウインドウサイズは3,900でお願い！）"Qualification_End;
	DESCRIPTIVE_PART_WAIT = "↓一定時間を待つ";
	# ---------------------------------------------------------------------
	Send_FromA_ToB_User_A = LightPurple_Bold_Start"A"Qualification_End;
	Send_FromA_ToB_User_B = LightPurple_Bold_Start"B"Qualification_End;
	Send_FromA_ToB_ARROW = LightPurple_Bold_Start"--->"Qualification_End;
	Send_FromA_ToB_ARROW_LAST = LightPurple_Bold_Start"A--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->B"Qualification_End;
	# ---------------------------------------------------------------------
	Receive_FromB_ToA_User_A = LightBlue_Bold_Start"A"Qualification_End;
	Receive_FromB_ToA_User_B = LightBlue_Bold_Start"B"Qualification_End;
	Receive_FromB_ToA_ARROW = LightBlue_Bold_Start"<---"Qualification_End;
	Receive_FromB_ToA_ARROW_LAST = LightBlue_Bold_Start"A<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---"Qualification_End;
	Receive_FromB_ToA_ARROW_LAST2 = LightBlue_Bold_Start"A<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---B"Qualification_End;
	# ---------------------------------------------------------------------
	# https://www.mm2d.net/main/prog/c/console-04.html
	CARRIAGE_RETURN = "\r";
	MAX_ARROW_LENGTH = 74;
	# ---------------------------------------------------------------------
}

