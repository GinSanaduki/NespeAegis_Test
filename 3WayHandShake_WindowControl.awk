#!/usr/bin/gawk -f
# 3WayHandShake_WindowControl.awk
# gawk -f 3WayHandShake_WindowControl.awk
# https://www.infraexpert.com/study/tcpip11.html

BEGIN{
	Init();
	print "\033[36;1m<<<ウインドウ制御の体験>>>\033[0m";
	print "例えば3,900バイトのデータを3回に分けて送信する時";
	print "1,300バイトのデータを送るたびにACKを待っていると通信速度は遅いですが";
	print "ウィンドウサイズが「3,900」であることを相手側のホストに伝えた場合";
	print "送信側はACKを待つことなく「3,900」バイトのデータを送信することができるので";
	print "通信速度が速まります。";
	UnWindowControl();
	WindowControl();
	print "\033[31mしかし、これではウィンドウサイズ分のデータを送信した後\033[0m";
	print "\033[31mACKを受信するまでの間の待ち時間が発生してしまいます。\033[0m";
	WindowControl_Wait();
	print "\033[36;1m<<<スライディングウィンドウの体験>>>\033[0m";
	print "スライディングウィンドウでは、受信側（ホストB）はデータを受信する度にACKを送ります。";
	print "最初のACKを受信したらその分のウィンドウをスライドさせるので";
	print "送信側（ホストA）はそのACKを待つことなく";
	print "ウィンドウサイズ分（3,900バイト）のデータを送り続けられます。";
	WindowControl_SlidingWindow();
	print "ホストAのデータ（ACKを1度も受信していない場合）";
	print "-----------------------------------------------------------------------------------------";
	print "|0           |  1300           |  2600           |  3900           |  5200           |  6500           |  7800 ";
	print "|             |                     |                     |                     |                     |                     |           ";
	print "|             |                     |                     |                     |                     |                     |           ";
	print "|    ①     |        ②         |         ③         |         ④        |           ⑤       |       ⑥          |    ⑦    ";
	print "|    ウィンドウ（ACKを待つこと       |                     |                     |                     |           ";
	print "|なく送信できるデータ）                  |                     |                     |                     |           ";
	print "|             |                     |                     |                     |                     |                     |           ";
	print "|             |                     |                     |                     |                     |                     |           ";
	print "-----------------------------------------------------------------------------------------";
	Sleep_3();
	print "ホストAのデータ（ホストAは初回送信のACKを受信）";
	print "-----------------------------------------------------------------------------------------";
	print "|0           |  1300           |  2600           |  3900           |  5200           |  6500           |  7800 ";
	print "|             |                     |                     |                     |                     |                     |           ";
	print "|             |                     |                     |                     |                     |                     |           ";
	print "|    ①     |        ②         |         ③         |         ④        |           ⑤       |       ⑥          |    ⑦    ";
	print "|             |        ウィンドウ（ACKを待つこと          |                     |                     |            ";
	print "|             |         なく送信できるデータ）                 |                     |                     |           ";
	print "|             |                     |                     |                     |                     |                     |           ";
	print "|             |                     |                     |                     |                     |                     |           ";
	print "-----------------------------------------------------------------------------------------";
	print "\033[36;1m<<<ウインドウ制御の体験>>>　　　完\033[0m";
}

function UnWindowControl(){
	print "・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・";
	print "ウインドウサイズを伝えない場合・・・";
	Sleep_1();
	for(i = 1; i <= 3; i++){
		print Send_FromA_ToB;
		print MSG_DATA_SEND_1300;
		Sleep_1();
		print Receive_FromB_ToA;
		print MSG_COMPLETE_RECEIVE;
		Sleep_1();
	}
	print "・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・";
}

function WindowControl(){
	print "・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・";
	print "ウインドウサイズを伝える場合・・・";
	Sleep_1();
	print Receive_FromB_ToA;
	print MSG_ANNOTATION_WINDOWSIZE_3900;
	Sleep_1();
	print Send_FromA_ToB;
	print MSG_ANNOTATION_DATA_SEND_1300;
	Sleep_1();
	for(i = 1; i <= 3; i++){
		print Send_FromA_ToB;
		print MSG_DATA_SEND_1300;
		Sleep_1();
	}
	print Receive_FromB_ToA;
	print MSG_COMPLETE_RECEIVE;
	Sleep_1();
	print "・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・";
}

function WindowControl_Wait(){
	print "・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・";
	Sleep_1();
	print Receive_FromB_ToA;
	print MSG_ANNOTATION_WINDOWSIZE_3900;
	Sleep_1();
	print Send_FromA_ToB;
	print MSG_ANNOTATION_DATA_SEND_1300;
	Sleep_1();
	for(i = 1; i <= 3; i++){
		print Send_FromA_ToB;
		print MSG_DATA_SEND_1300;
		Sleep_1();
	}
	print Receive_FromB_ToA;
	print MSG_COMPLETE_RECEIVE;
	Sleep_1();
	for(i = 1; i <= 1; i++){
		print Send_FromA_ToB;
		print MSG_DATA_SEND_1300;
		Sleep_1();
	}
	print "・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・";
}

function WindowControl_SlidingWindow(){
	print "・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・";
	Sleep_1();
	print Receive_FromB_ToA;
	print MSG_ANNOTATION_WINDOWSIZE_3900;
	Sleep_1();
	print Send_FromA_ToB;
	print MSG_ANNOTATION_DATA_SEND_1300;
	Sleep_1();
	for(i = 1; i <= 3; i++){
		print Send_FromA_ToB;
		print MSG_DATA_SEND_1300_SLIDINGWINDOW;
		print Receive_FromB_ToA;
		print MSG_COMPLETE_RECEIVE;
	}
	for(i = 1; i <= 3; i++){
		print Send_FromA_ToB;
		print MSG_DATA_SEND_1300_SLIDINGWINDOW;
		print Receive_FromB_ToA;
		print MSG_COMPLETE_RECEIVE;
	}
	print "以下略・・・";
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
	CMD_SLEEP_1 = "sleep 1";
	CMD_SLEEP_3 = "sleep 3";
	Send_FromA_ToB = "\033[35;1mA--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->B\033[0m";
	Receive_FromB_ToA = "\033[36;1mA<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---B\033[0m";
	MSG_DATA_SEND_1300 = "\033[35;1mデータを1,300byte送るよ。\033[0m";
	MSG_DATA_SEND_1300_SLIDINGWINDOW = "\033[35;1mACKを待つことなく、データを1,300byte送るよ。\033[0m";
	MSG_ANNOTATION_DATA_SEND_1300 = "\033[35;1m了解。3,900バイトまではACKを待つことなくデータを送るね。\033[0m";
	MSG_COMPLETE_RECEIVE = "\033[36;1mACK（受け取った。）\033[0m";
	MSG_ANNOTATION_WINDOWSIZE_3900 = "\033[36;1mウインドウサイズは3,900！\033[0m";
}

