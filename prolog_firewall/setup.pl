start():-P = '', adapter(P).

adapter([]).
adapter(P):- format('Enter the adpater you want to use:'), read(X), concat(P,X,R), format('Do you want to add more adapters?'), read(W), (W = 'yes', concat(R,':',Q), adapter(Q); W = 'no', concat(R,':flag',V), L = [row(V)], ether(L)).

ether([]).
ether(L):- format('Do you want to allow IPv4 Ether Type?'), read(Y), ((Y = 'yes', A = 1, L1 = row('0000100000000000a'), M = [L1|L], L2 = row('IPV4'), N = [L2|M], L3 = row(1), O = [L3|N]); (Y = 'no', A = 0)) , format('Do you want to allow IPv6 Ether Type?'), read(W), ((W = 'yes', B = 1, L4 = row('1000011011011101a'), (A = 0, P = [L4|L]; A =1, P = [L4|O]), L5 = row('IPV6'), Q = [L5|P], L6 = row(2), R = [L6|Q]); (W = 'no', B = 0)), L7 = row('t'), (B = 1, S = [L7|R]; B = 0, S =[L7|O]), blockIP(S,A,B).

blockIP([],_,_).
blockIP(L,X,Y):- (X = 1, format('Enter the IP address to be blocked for IPV4'), read(Z), concat('1x',Z,R), L1 = row(R), M = [L1|L], format('Do you want to add more?'), read(W), (W = 'yes',blockIP(M,X,Y); W = 'no', blockIP(M,0,Y))); (Y = 1, format('Enter IP add to be blocked for IPV6:'), read(V), concat('2x',V,S), L2 = row(S), N = [L2|L], format('Do you want to add more?'), read(U), (U = 'yes', blockIP(N,0,Y); U = 'no', blockIP(N,0,0))); (L3 = row('t'), L4 = row('end'), M = [L3|L], N = [L4|M], reverseList(N,[])).      	

reverseList([],[]).
reverseList([A|B],L):- L1 = [A|L], (B = [], csv_write_file('data.csv',L1); reverseList(B,L1)).

