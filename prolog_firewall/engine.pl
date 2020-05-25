packetChk([]).
packetChk([A|B]):- format('Sending packet through firewall.~n',A), csv_read_file('data.csv',Data), Data = [C|D], row(X) = C, split_string(X,':','',L), adapterChk([A|B],L,D).

adapterChk([],[],[]).
adapterChk([A|B],[E|F],D):- F = [], format('Not allowed to use adapter ~w.~n',A); atom_string(A,R), R = E, format('Using adapter ~w.~n',A), vLanChk(B,D); adapterChk([A|B],F,D).  

vLanChk([],[]).
vLanChk([A|B],[C|D]):- A = '1000000100000000', format('VLAN, hence rejected.~n'); etherTypeCheck([A|B],[C|D]).

etherTypeCheck([],[]).
etherTypeCheck([A|B],[C|D]):- D = [E|F], F = [G|H], H=[I|J], row(Y) = E, row(Z) = G, row(W) = I, row(X) = C, split_string(X,'a','',L1), L1 = [P|Q], atom_string(A,R), (P = R, format('~w~n',Y), (W = 't', ipAdd(B,J,Z); J = [K|L], L = [M|N], N = [O|S], ipAdd(B,S,Z)); (W = 't', format('Ether type doesnt exist.'); etherTypeCheck([A|B],H))).

ipAdd([],[],_,_).
ipAdd([A|B],[C|D],X):- row(P) = C, (P = 't', format('~w/ This URL is allowed.~n',A), protoChk(B,X); split_string(P,'x','',L), L = [E|F], atom_string(X,S), (S = E, F = [G|H], atom_string(A,Q), G = Q, format('~w/ URL not allowed.~n',A); ipAdd([A|B],D,X))).

protoChk([],_).
protoChk([A|B],X):- A = '00000110', format('TCP.~n'), csv_read_file('tcp1.csv',Data), tcpChk(B,Data); A = '00010001', format('UDP.~n'), csv_read_file('tcp1.csv',Data), tcpChk(B,Data); A = '00000001', (X = 1, format('ICMP~n'); X = 2, format('ICMPv6.~n')), csv_read_file('icmp1.csv',Data), icmpChk(B,Data,X); format('Unknown protocol number.~n'),!.

tcpChk([],[]).
tcpChk([A|B],[C|D]):- row(X) = C, split_string(X,';','',L), L = [E|F], split_string(E,'a','',R), R = [P|Q], atom_string(A,G), G = P, F = [I|J], format('~w.~n',I); tcpChk([A|B],D); !.

icmpChk([],[],_).
icmpChk([A|B],[C|D],X):- row(W) = C, split_string(W,';','',L), L = [E|F], F = [G|H], H = [I|J], J = [K], atom_string(X,R), (R = E, split_string(G,'a','',L1), L1 = [U|V], atom_string(A,Q), Q = U, B = [N|O], split_string(I,'a','',L2), L2 = [S|T], atom_string(N,M), M = S, format('~w.~n',K); icmpChk([A|B],D,X); !).

