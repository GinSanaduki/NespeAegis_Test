#!/usr/bin/gawk -f
# 3WayHandShake.awk
# gawk -f 3WayHandShake.awk
# https://www.infraexpert.com/study/tcpip9.html

BEGIN{
	Init();
	print "3ウェイハンドシェイクの出題です。";
	print "以下の手順の通り、\0423回のやりとり\042によって確立されます。";
	HandShake_SYN();
	HandShake_SYN_ACK();
	HandShake_ACK();
	print "次に、3ウェイハンドシェイクにより確立したコネクション上でデータをやりとりする時の流れを見てみます。";
	for(i = 1; i <= EndCount; i++){
		HandShakeAfter_Send();
		HandShakeAfter_Receive();
	}
	print "最後に、データのやりとりが完了してから通信を終了（コネクションの切断）する時のやりとりを見てみます。";
	print "コネクションの接続は\0423回\042のやりとりでしたが、コネクションの切断は\0424回\042のやりとりが必要となります。";
	DisConnect_01();
	DisConnect_02();
	DisConnect_03();
	DisConnect_04();
	print "TCPコネクションが正常に終了しました。";
	exit;
}

function Init(){
	CMD_RAND_1 = "shuf -i 0-1000 -n 1";
	CMD_RAND_2 = "shuf -i 100-10000 -n 1";
	Sequence_SYN = 0;
	Sequence_SYN_ACK = 0;
	Set_Sequence_Answer = 0;
	Set_ACK_Sharp_Number_Answer = 0;
	Before_DisConnect_Sequence_Answer = 0;
	Before_DisConnect_ACK_Sharp_Number_Answer = 0;
	DataSize = 0;
	Send_FromA_ToB = "A--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->B";
	Receive_FromB_ToA = "A<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---<---B";
	ActionCnt = 1;
	EndCount = 2;
	Vector = "Send_FromA_ToB";
}

function Exec_Rand_01(Local_Esc, Local_Adjust){
	while(CMD_RAND_1 | getline Local_Esc){
		break;
	}
	close(CMD_RAND_1);
	Local_Adjust = Local_Esc + 0;
	#if(Local_Adjust == 0){
	#	return 0;
	#}
	#if(Local_Adjust % 100 == 0){
	#	return Local_Adjust;
	#}
	#Local_Adjust = Local_Adjust / 100;
	#Local_Adjust = 100 * (Local_Adjust + 1);
	return Local_Adjust;
}

function Exec_Rand_02(Local_Esc, Local_Adjust){
	while(CMD_RAND_2 | getline Local_Esc){
		break;
	}
	close(CMD_RAND_2);
	Local_Adjust = Local_Esc + 0;
	#if(Local_Adjust == 0){
	#	return 0;
	#}
	#if(Local_Adjust % 100 == 0){
	#	return Local_Adjust;
	#}
	#Local_Adjust = Local_Adjust / 100;
	#Local_Adjust = 100 * (Local_Adjust + 1);
	return Local_Adjust;
}

function Correct(){
	print "あたり　　　です！";
}

function InCorrect(Args_CorrectValue){
	print "ばか　　　はずれです・・・・・・";
	print "正解："Args_CorrectValue;
}

function Reply(Local_Buff){
	getline Local_Buff < "-";
	if(Local_Buff == ""){
		print "終了します。";
		exit;
	}
	Local_Buff = Local_Buff + 0;
	return Local_Buff;
}

function DisConnect_01(Local_SYN_Answer, Local_FIN_Answer, Local_Sequence_Answer, Local_ACK_Sharp_Number_Answer){
	print "Action."ActionCnt"：切断していい？";
	ActionCnt++;
	if(Vector == "Send_FromA_ToB"){
		print Send_FromA_ToB;
	} else {
		print Receive_FromB_ToA;
	}
	print "SYN：？FIN：？　　　シーケンス番号：？　　　確認応答番号：？";
	print "SYNはいくつ？";
	Local_SYN_Answer = 1;
	if(Reply() == Local_SYN_Answer){
		Correct();
	} else {
		InCorrect(Local_SYN_Answer);
	}
	print "FINはいくつ？";
	Local_FIN_Answer = 1;
	if(Reply() == Local_ACK_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Answer);
	}
	print "シーケンス番号はいくつ？";
	Local_Sequence_Answer = Before_DisConnect_Sequence_Answer;
	if(Reply() == Sequence_SYN_ACK){
		Correct();
	} else {
		InCorrect(Sequence_SYN_ACK);
		print "シーケンス番号は「直前の自分のシーケンス番号」+「自分が送信したデータサイズ」となります。";
	}
	print "確認応答番号はいくつ？";
	Local_ACK_Sharp_Number_Answer = Before_DisConnect_ACK_Sharp_Number_Answer;
	if(Reply() == Local_ACK_Sharp_Number_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Sharp_Number_Answer);
		print "確認応答番号はそのまま引き継がれます。";
	}
	if(Vector == "Send_FromA_ToB"){
		Vector = "Receive_FromB_ToA";
	} else {
		Vector = "Send_FromA_ToB";
	}
}

function DisConnect_02(Local_SYN_Answer, Local_FIN_Answer, Local_Sequence_Answer, Local_ACK_Sharp_Number_Answer){
	print "Action."ActionCnt"：OK！";
	ActionCnt++;
	if(Vector == "Send_FromA_ToB"){
		print Send_FromA_ToB;
	} else {
		print Receive_FromB_ToA;
	}
	print "SYN：？FIN：？　　　シーケンス番号：？　　　確認応答番号：？";
	print "SYNはいくつ？";
	Local_SYN_Answer = 1;
	if(Reply() == Local_SYN_Answer){
		Correct();
	} else {
		InCorrect(Local_SYN_Answer);
	}
	print "FINはいくつ？";
	Local_FIN_Answer = 0;
	if(Reply() == Local_ACK_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Answer);
	}
	print "シーケンス番号はいくつ？";
	Local_Sequence_Answer = Before_DisConnect_ACK_Sharp_Number_Answer;
	if(Reply() == Sequence_SYN_ACK){
		Correct();
	} else {
		InCorrect(Sequence_SYN_ACK);
		print "シーケンス番号は「相手から受信した確認応答番号」です。";
	}
	print "確認応答番号はいくつ？";
	Local_ACK_Sharp_Number_Answer = Before_DisConnect_Sequence_Answer + 1;
	if(Reply() == Local_ACK_Sharp_Number_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Sharp_Number_Answer);
		print "確認応答番号は、今回のようにFINへの確認応答の場合「相手から受信したシーケンス番号」に「1」を加算します。";
	}
	Set_Sequence_Answer = Local_Sequence_Answer;
	Set_ACK_Sharp_Number_Answer = Local_ACK_Sharp_Number_Answer;
}

function DisConnect_03(Local_SYN_Answer, Local_FIN_Answer, Local_Sequence_Answer, Local_ACK_Sharp_Number_Answer){
	print "Action."ActionCnt"：こちらからも切断していい？";
	ActionCnt++;
	if(Vector == "Send_FromA_ToB"){
		print Send_FromA_ToB;
	} else {
		print Receive_FromB_ToA;
	}
	print "SYN：？FIN：？　　　シーケンス番号：？　　　確認応答番号：？";
	print "SYNはいくつ？";
	Local_SYN_Answer = 1;
	if(Reply() == Local_SYN_Answer){
		Correct();
	} else {
		InCorrect(Local_SYN_Answer);
	}
	print "FINはいくつ？";
	Local_FIN_Answer = 1;
	if(Reply() == Local_ACK_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Answer);
	}
	print "シーケンス番号はいくつ？";
	Local_Sequence_Answer = Set_Sequence_Answer;
	if(Reply() == Sequence_SYN_ACK){
		Correct();
	} else {
		InCorrect(Sequence_SYN_ACK);
		print "シーケンス番号はそのまま引き継がれます。";
	}
	print "確認応答番号はいくつ？";
	Local_ACK_Sharp_Number_Answer = Set_ACK_Sharp_Number_Answer;
	if(Reply() == Local_ACK_Sharp_Number_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Sharp_Number_Answer);
		print "確認応答番号はそのまま引き継がれます。";
	}
	if(Vector == "Send_FromA_ToB"){
		Vector = "Receive_FromB_ToA";
	} else {
		Vector = "Send_FromA_ToB";
	}
}

function DisConnect_04(Local_SYN_Answer, Local_FIN_Answer, Local_Sequence_Answer, Local_ACK_Sharp_Number_Answer){
	print "Action."ActionCnt"：OK！";
	ActionCnt++;
	if(Vector == "Send_FromA_ToB"){
		print Send_FromA_ToB;
	} else {
		print Receive_FromB_ToA;
	}
	print "SYN：？FIN：？　　　シーケンス番号：？　　　確認応答番号：？";
	print "SYNはいくつ？";
	Local_SYN_Answer = 1;
	if(Reply() == Local_SYN_Answer){
		Correct();
	} else {
		InCorrect(Local_SYN_Answer);
	}
	print "FINはいくつ？";
	Local_FIN_Answer = 0;
	if(Reply() == Local_ACK_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Answer);
	}
	print "シーケンス番号はいくつ？";
	Local_Sequence_Answer = Set_ACK_Sharp_Number_Answer;
	if(Reply() == Sequence_SYN_ACK){
		Correct();
	} else {
		InCorrect(Sequence_SYN_ACK);
		print "シーケンス番号は「相手から受信した確認応答番号」です。";
	}
	print "確認応答番号はいくつ？";
	Local_ACK_Sharp_Number_Answer = Set_Sequence_Answer + 1;
	if(Reply() == Local_ACK_Sharp_Number_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Sharp_Number_Answer);
		print "確認応答番号は、今回のようにFINへの応答確認の場合は「相手から受信したシーケンス番号」に「1」を加算します。";
	}
}


function HandShakeAfter_Send(){
	DataSize = Exec_Rand_02();
	print "Action."ActionCnt"：データを"DataSize"byte送るよ。";
	ActionCnt++;
	print Send_FromA_ToB;
	if(ActionCnt == 5){
		print "SYN：？ACK：？　　　シーケンス番号：？　　　確認応答番号：？";
		print "SYNはいくつ？";
		Local_SYN_Answer = 0;
		if(Reply() == Local_SYN_Answer){
			Correct();
		} else {
			InCorrect(Local_SYN_Answer);
		}
		print "ACKはいくつ？";
		Local_ACK_Answer = 1;
		if(Reply() == Local_ACK_Answer){
			Correct();
		} else {
			InCorrect(Local_ACK_Answer);
		}
	} else {
		print "SYN：0　　　ACK：1　　　シーケンス番号：？　　　確認応答番号：？";
	}
	print "シーケンス番号はいくつ？";
	if(ActionCnt == 5){
		Local_Sequence_Answer = Set_Sequence_Answer;
	} else {
		Local_Sequence_Answer = Set_ACK_Sharp_Number_Answer;
	}
	if(Reply() == Sequence_SYN_ACK){
		Correct();
	} else {
		InCorrect(Sequence_SYN_ACK);
		if(ActionCnt == 5){
			print "データ転送では、3ウェイハンドシェイク後のシーケンス番号の値を引き続き使用します。";
		} else {
			print "シーケンス番号は、「相手から受信した確認応答番号」を使用します。";
		}
	}
	print "確認応答番号はいくつ？";
	if(ActionCnt == 5){
		Local_ACK_Sharp_Number_Answer = Set_ACK_Sharp_Number_Answer;
	} else {
		Local_ACK_Sharp_Number_Answer = Set_Sequence_Answer + DataSize;
	}
	if(Reply() == Local_ACK_Sharp_Number_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Sharp_Number_Answer);
		if(ActionCnt == 5){
			print "データ転送では、3ウェイハンドシェイク後の確認応答番号の値を引き続き使用します。";
		} else {
			print "確認応答番号は「相手から受信したシーケンス番号」にデータサイズを加えた値となります。";
		}
	}
	Before_DisConnect_Sequence_Answer = Local_Sequence_Answer + DataSize;
	Before_DisConnect_ACK_Sharp_Number_Answer = Local_ACK_Sharp_Number_Answer;
	Vector = "Send_FromA_ToB";
}

function HandShakeAfter_Receive(){
	DataSize = Exec_Rand_02();
	print "Action."ActionCnt"：データを"DataSize"byte送るよ。";
	ActionCnt++;
	print Receive_FromB_ToA;
	if(ActionCnt == 6){
		print "SYN：？ACK：？　　　シーケンス番号：？　　　確認応答番号：？";
		print "SYNはいくつ？";
		Local_SYN_Answer = 0;
		if(Reply() == Local_SYN_Answer){
			Correct();
		} else {
			InCorrect(Local_SYN_Answer);
		}
		print "ACKはいくつ？";
		Local_ACK_Answer = 1;
		if(Reply() == Local_ACK_Answer){
			Correct();
		} else {
			InCorrect(Local_ACK_Answer);
		}
	} else {
		print "SYN：0　　　ACK：1　　　シーケンス番号：？　　　確認応答番号：？";
	}
	print "シーケンス番号はいくつ？";
	Local_Sequence_Answer = Set_Sequence_Answer;
	if(Reply() == Sequence_SYN_ACK){
		Correct();
	} else {
		InCorrect(Sequence_SYN_ACK);
		if(ActionCnt == 5){
			print "データ転送では、3ウェイハンドシェイク後のシーケンス番号の値を引き続き使用します。";
		} else {
			print "シーケンス番号は、「相手から受信した確認応答番号」を使用します。";
		}
	}
	print "確認応答番号はいくつ？";
	Local_ACK_Sharp_Number_Answer = Set_ACK_Sharp_Number_Answer;
	if(Reply() == Local_ACK_Sharp_Number_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Sharp_Number_Answer);
		if(ActionCnt == 5){
			print "データ転送では、3ウェイハンドシェイク後の確認応答番号の値を引き続き使用します。";
		} else {
			print "確認応答番号は「相手から受信したシーケンス番号」にデータサイズを加えた値となります。";
		}
	}
	Set_Sequence_Answer = Local_ACK_Sharp_Number_Answer;
	Set_ACK_Sharp_Number_Answer = Local_Sequence_Answer + DataSize;
	Before_DisConnect_Sequence_Answer = Local_Sequence_Answer + DataSize;
	Before_DisConnect_ACK_Sharp_Number_Answer = Local_ACK_Sharp_Number_Answer;
	Vector = "Receive_FromB_ToA";
}

function HandShake_SYN(Local_SYN_Answer, Local_ACK_Answer){
	print "Action."ActionCnt"：接続を開始していい？";
	ActionCnt++;
	print Send_FromA_ToB;
	Sequence_SYN = Exec_Rand_01();
	print "SYN：？ACK：？　　　シーケンス番号："Sequence_SYN;
	print "SYNはいくつ？";
	Local_SYN_Answer = 1;
	if(Reply() == Local_SYN_Answer){
		Correct();
	} else {
		InCorrect(Local_SYN_Answer);
	}
	print "ACKはいくつ？";
	Local_ACK_Answer = 0;
	if(Reply() == Local_ACK_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Answer);
	}
	print "なお、確認応答番号(いわゆるACK番号）は通信の開始にはありません。";
	print "豆知識な・・・。";
}

function HandShake_SYN_ACK(Local_SYN_Answer, Local_ACK_Answer, Local_ACK_Sharp_Number_Answer){
	print "Action."ActionCnt"：OK！こちらからも接続を開始していい？";
	ActionCnt++;
	print Receive_FromB_ToA;
	Sequence_SYN_ACK = Exec_Rand_01();
	print "SYN：？ACK：？　　　シーケンス番号："Sequence_SYN_ACK"　　　確認応答番号：？";
	print "SYNはいくつ？";
	Local_SYN_Answer = 1;
	if(Reply() == Local_SYN_Answer){
		Correct();
	} else {
		InCorrect(Local_SYN_Answer);
	}
	print "ACKはいくつ？";
	Local_ACK_Answer = 1;
	if(Reply() == Local_ACK_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Answer);
	}
	print "確認応答番号はいくつ？";
	Local_ACK_Sharp_Number_Answer = Sequence_SYN + 1;
	if(Reply() == Local_ACK_Sharp_Number_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Sharp_Number_Answer);
		print "確認応答番号は「相手から受信したシーケンス番号」＋「データサイズの値」";
		print "ですが、3ウェイハンドシェイクでは「相手から受信したシーケンス番号」に「1」を加算した値となります。";
	}
	Set_Sequence_Answer = Sequence_SYN_ACK;
	Set_ACK_Sharp_Number_Answer = Local_ACK_Sharp_Number_Answer;
}

function HandShake_ACK(Local_SYN_Answer, Local_ACK_Answer, Local_Sequence_Answer, Local_ACK_Sharp_Number_Answer){
	print "Action."ActionCnt"：OK！";
	ActionCnt++;
	print Send_FromA_ToB;
	print "SYN：？ACK：？　　　シーケンス番号：？　　　確認応答番号：？";
	print "SYNはいくつ？";
	Local_SYN_Answer = 0;
	if(Reply() == Local_SYN_Answer){
		Correct();
	} else {
		InCorrect(Local_SYN_Answer);
	}
	print "ACKはいくつ？";
	Local_ACK_Answer = 1;
	if(Reply() == Local_ACK_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Answer);
	}
	print "シーケンス番号はいくつ？";
	Local_Sequence_Answer = Set_ACK_Sharp_Number_Answer;
	if(Reply() == Set_ACK_Sharp_Number_Answer){
		Correct();
	} else {
		InCorrect(Set_ACK_Sharp_Number_Answer);
		print "シーケンス番号は「相手から受信した確認応答番号」です。";
	}
	print "確認応答番号はいくつ？";
	Local_ACK_Sharp_Number_Answer = Set_Sequence_Answer + 1;
	if(Reply() == Local_ACK_Sharp_Number_Answer){
		Correct();
	} else {
		InCorrect(Local_ACK_Sharp_Number_Answer);
		print "確認応答番号は②と同じ考え方なので「相手から受信したシーケンス番号」に「1」を加算した値となります。";
	}
	Set_Sequence_Answer = Local_Sequence_Answer;
	Set_ACK_Sharp_Number_Answer = Local_ACK_Sharp_Number_Answer;
}

