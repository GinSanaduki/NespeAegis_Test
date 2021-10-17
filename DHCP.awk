#!/usr/bin/gawk -f
# DHCP.awk
# gawk -f DHCP.awk
# https://www.infraexpert.com/study/tcpip13.html

BEGIN{
	Init();
	print LightBlue_Bold_Start"<<<DHCPの体験>>>"Qualification_End;
	DHCP_Base();
	DHCP_Discover();
	#DHCP_Offer();
	#DHCP_Request();
	#DHCP_Ack();
	print LightBlue_Bold_Start"<<<DHCPの体験>>>　　　完"Qualification_End;
}

function DHCP_Discover(Local_DHCPServer_PortNo_Answer, Local_DHCPClient_PortNo_Answer){
	print "DHCPプロトコルはUDP上で動作するプロトコルです。";
	print "問題：DHCPサーバ宛にパケットを送る場合のポート番号は？";
	Local_DHCPServer_PortNo_Answer = 67;
	if(Reply() == Local_DHCPServer_PortNo_Answer){
		Correct();
	} else {
		InCorrect(Local_DHCPServer_PortNo_Answer);
	}
	print "問題：DHCPクライアント宛にパケットを送る場合のポート番号は？";
	Local_DHCPClient_PortNo_Answer = 68;
	if(Reply() == Local_DHCPClient_PortNo_Answer){
		Correct();
	} else {
		InCorrect(Local_DHCPClient_PortNo_Answer);
	}
}

function DHCP_Base(Local_DHCPServer_PortNo_Answer, Local_DHCPClient_PortNo_Answer){
	print "DHCPプロトコルはUDP上で動作するプロトコルです。";
	print "問題：DHCPサーバ宛にパケットを送る場合のポート番号は？";
	Local_DHCPServer_PortNo_Answer = 67;
	if(Reply() == Local_DHCPServer_PortNo_Answer){
		Correct();
	} else {
		InCorrect(Local_DHCPServer_PortNo_Answer);
	}
	print "問題：DHCPクライアント宛にパケットを送る場合のポート番号は？";
	Local_DHCPClient_PortNo_Answer = 68;
	if(Reply() == Local_DHCPClient_PortNo_Answer){
		Correct();
	} else {
		InCorrect(Local_DHCPClient_PortNo_Answer);
	}
}

function Correct(){
	print LightBlue_Bold_Start"あたり　　　です！"Qualification_End;
}

function InCorrect(Args_CorrectValue){
	print Red_Bold_Start"ばか　　　はずれです・・・・・・"Qualification_End;
	print LightPurple_Bold_Start"正解："Qualification_End Args_CorrectValue;
}

function Reply(Local_Buff){
	getline Local_Buff < "-";
	if(Local_Buff == ""){
		print LightPurple_Bold_Start"終了します。"Qualification_End;
		exit;
	}
	Local_Buff = Local_Buff + 0;
	return Local_Buff;
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

function Sleep_1(){
	system(CMD_SLEEP_1);
	close(CMD_SLEEP_1);
}

function Sleep_3(){
	system(CMD_SLEEP_3);
	close(CMD_SLEEP_3);
}

function Rand_256(Local_Rand){
	while(CMD_RAND_256 | getline Local_Rand){
		break;
	}
	close(CMD_RAND_256);
	return Local_Rand + 0;
}

function Rand_256_Hex(Local_Rand, Local_Rand_Hex, Local_CMD_RAND_256_HEX){
	while(CMD_RAND_256 | getline Local_Rand){
		break;
	}
	close(CMD_RAND_256);
	Local_Rand = Local_Rand + 0;
	Local_CMD_RAND_256_HEX = CMD_RAND_256_HEX Local_Rand;
	
	while(Local_CMD_RAND_256_HEX | getline Local_Rand_Hex){
		break;
	}
	close(Local_CMD_RAND_256_HEX);
	return Local_Rand_Hex;
}

function Init(){
	LightBlue_Bold_Start = "\033[36;1m";
	LightPurple_Bold_Start = "\033[35;1m";
	Red_Bold_Start = "\033[31;1m";
	Qualification_End = "\033[0m";
	# ---------------------------------------------------------------------
	CMD_SLEEP_1 = "sleep 1";
	CMD_SLEEP_3 = "sleep 3";
	CMD_RAND_256 = "shuf -i 0-255 -n 1";
	CMD_RAND_256_HEX = "printf \047%X\n\047 ";
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
	# IPアドレス
	while(1){
		DHCP_CLIENT_IP_ADDRESS = "192.168."Rand_256()"."Rand_256();
		DHCP_Server_IP_ADDRESS = "192.168."Rand_256()"."Rand_256();
		if(DHCP_CLIENT_IP_ADDRESS != DHCP_Server_IP_ADDRESS){
			break;
		}
	}
	# print "DHCP_CLIENT_IP_ADDRESS : "DHCP_CLIENT_IP_ADDRESS;
	# print "DHCP_Server_IP_ADDRESS : "DHCP_Server_IP_ADDRESS;
	# MACアドレス
	OUI = "52:42:00:";
	while(1){
		DHCP_CLIENT_MAC_ADDRESS = GenerateMACAddress();
		DHCP_Server_MAC_ADDRESS = GenerateMACAddress();
		if(length(DHCP_CLIENT_MAC_ADDRESS) != 17 || length(DHCP_Server_MAC_ADDRESS) != 17){
			continue;
		}
		if(DHCP_CLIENT_MAC_ADDRESS != DHCP_Server_MAC_ADDRESS){
			break;
		}
	}
	# print "DHCP_CLIENT_MAC_ADDRESS : "DHCP_CLIENT_MAC_ADDRESS;
	# print "DHCP_Server_MAC_ADDRESS : "DHCP_Server_MAC_ADDRESS;
}

function GenerateMACAddress(){
	return OUI Rand_256_Hex()":"Rand_256_Hex()":"Rand_256_Hex();
}

