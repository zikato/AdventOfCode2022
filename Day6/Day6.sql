USE AoC2022

DECLARE @input varchar(MAX) = 'lrdrgrcggjrgrddfqfqrqppptrtssnqqqlzqqslspppsddfnnwgnnwhhjttnsnswnnbqbrrcqrqdqcdddlnddwwlmmlmtmwmggjgjmmmrppqhhswhwhmhchtchhsttvbtvvpspjjqrrgqrqmqvmvzmvzzrnnqlnlwlttjstjtjvjddrzzrnrmrbmbwwzppnqpqmmjnnvqnvvdzdpdvvmhvhhmshmsssvnnqppclcqlcqctqtfffvrfvrffptfftppncncwnntfntftdftfhfzzfwzzcddngdndccrttjmmcddrvrwwnntggghccjbjvbvjvlvjlvlgljlnjjtvjjfddmwwhnnqnrnccwllpmprmmspsvsrsslstsllpmllfzlflqltlssdbbdsdqsdqqgfgfjjtzjzmmsnsmnnzssgfgzgjgwwqfqtfthhhczzpwprwwqttqcqctcpcrrvwrvrggfvfqvvbqqhnnczcjjjfbfhbhjhssnwwfswszwwgbgzgczcbbvmvrrdgrddfwdffvsvtstztftfvfssgffnrnnzzqddltdtbdttnnfrnnfrfddpmpqqplqqbdbzbnnnrttjfttprtrllqhhwjhjghjjcrcqqznztzllldjjhqqspsfpfprrsfspsrrzbbjmjssnjnsjnjllbttgrtrnnqhhvjhvvrrplrprtrtprtrdtdfttwdttqtttwvtvtmtntnnfvfsfnndsnnnfqfmmcdmdppsmpmnnwhhlwwrvwrwvwlwnwhwjwvwbvwvnnqtnnttcgtccbggzgwzwczcpzcpzpzgzngnzzhfhdhzzzsggtssddgtdtndtdllpbpjpgjjsllvqvmmvjmvjvbbfzzbdzzghhzjzvvnffwsshqhqhjhmmtgmgpmgmpmzzzhtzzbzsbzsbzszvsvgsvspvsstwtgwgqgjggsfsmffhlhmhdmhmgmrmffjcjggqgsghgttjffprpmmscsggswssgzzsqzqjqwqjwqwswjjqpjpllwrwffvfbfpbffjsswgsshjsjqssqrrvcrrnvvdnnwndnffpdffjlffrjrlrqrmmlzlttpccgchggdjjhwwvqvvrprdrttlvvtlvtlvvvhqhwhmmpmrrjsrrzbzfzdzhdzzwgwwqllmmthmmvpprqprrzmrrfrmfrrmfmjmwwhtwhttnbbhbnnhbnnmhmgmjgmgfmmhpplwplwlswwjjbpbhpbbzmmgjmmggbzbssppjtttfmfwwcwmmbmrmbrblbmmszzvgvzgvgvdggjgsjgsjgghfgfngffsnfssdpdgpgrgnrggrlggdwgdgddfwddjdrrppnnqbnntmmrmlmrrgvvqjjwzzgnzzdtzzbccnbcbttbzzcqqrcqqpspbphbphhnpnccggczcgcpgcpctppqwpwccsgsttgtbttvftfcfbfvfppfpnpffmjmljmmrtrsrttnhhcvctclttrffhzhrzzdpzzwvwddcggpbptbpbzpzdpzddbjjdvvwmmfvfcfmfmmvrmvrmmcdmdqqhjqhqmmstmmdnnvssmbsmmnhmnmlmttlthtvhvvgbvgvbvqbvbvnbvvpwwhwsszpszppjljsllzhzcchmhdhphvvtpvvfssvmvcmmrjmmgfmfwmfmsspbbpnnsbsgbbzzllzzsqqswqqsbqqlvqlqzzbrzzqsqdqjqzqlqccqbqlblpprrthrttjzzfvzzpvpbppqjpjjtllmrmzzwnnrggpfpllwhhnmnpmmdppwnnwpnnzlzggvpvgpprdrzddlmddjndjjrljlsjshhqbbhhmhvhqhzqqlbqlqnqqmhmwmhwwgbwbpbhpbblnnshnshslllrcrncctnthtllmglmlmnmfnfllrbrmdqsncjfbjnghmvpctfzttqwsfptwhfhmdhzgbmrpqvsbbwdwdnqgclrgvdbqvtnzvlzmdjzgbhbtqjhrgqqjgwcvpqhhwsmmflgsjsvbnjcjcqwqqfcbvfrllbpphfglptjfczmnfnrmqdgrhbvrddwvhnbffsnzntvldrwmgqmqdbmmpdjhpdqfsbzsfbtdzlfjwtwfpfrhzcwwrcfpdjzjzqvcnhvdvlbdbjfrnmchdjprbfpzdtmjhdjtrwfrsghngbswhfzdfvhdmnqwnpspdjgsfcjjhrlnpncfdhzfzglgvrjlzdcncbfjhpnrvwnqbzhtdfcnpnpddsnjcbgdvzlsmpnlbftgjfsjsslljppjhtjfddmwbtrvmhvshnvhhfdsqhpmgzfrcqtpdmfcwglnbjzmtmzshzsrnbzlwlzdjzzsqfmjzbnprjdzswwcgjjwslhnfhbflvcpdfzwhzzjmfvpfhzbrcdvtlmbvrqvvtlpbdnshtsvlcnlwqzcnfhzndfjbhgwpvspdvhfptnfvwznscmgthspwpjfwlbbcrzgthrhnvscvfvwrwvtzpjqmwdbjjslvzlmqstzwqtsdsqqjpqthgnshpjncwgvppngvvfrjpztftgjbbmgdddrcgjggwpfrvfqbnzvwtscftbwfssmrgrbchjmvqcdgbdmmsswvplnvnjrnqzhttbzhlthzjslgtgrnqpghtbjnbftpdttvqhrljhnfqllrhfmzcnnwrljmchsvdbgvwmrpfzjsbngpffpgntrgflntbjnjwqbdhvhssvptdvvqvtrgqhhzrcfnnmbtzqrcghggcqhndggqzzgswflhqqrgmnggbrvpwqgtlptgmzdvgztgfqdzwnbrvvqhpnmcmptqljmqqmsslfcmgpnmnjmrsngrtbsffqbwlhsrwbzdcqvpbptpjphcjnwsmrjdbbrwftsnrgfhpjvsjcwpmpvfjtjvfnnwdjdttsjrqrgsznzqwjmsvscdtpptmdhqvwngtldtsnstjmwwrwwzdzvtndrrhgsgshzlpdrmlsgvplvbfrffvgvhmncbjdlqspbpdpcdsffrjzptltsznwwqbvnrwfdtrlbbvsmzjrhhvscqfwsqtmwnpjfgnjcttwphtqqhnvgjmzvczcrlmjjgwgnprcmmprltfrgrjlhvggdwvpnrqrtfwhpsfnjfvmvgzpmhrqmggldmsvztwcwzgblfbvbfvnshrdppzcvjwbjmsncwnbnjwbmwqjjwtjmwzpdvpwrfdtrqhnltgntvglgspvnbcsvnpppwmgphhsdqtpmrzmbdqlghsgjnnbhflzwghzzhdfsvjjcjfcssmvrmfqbgzcfwmhpvjqqrrhpsffczwgbjgwqlvzrvnhvzrqnfllqtrcjhmpdjfpqnlzhdnsctbfhsbpgwqdjdjhfbqzvzpsgmqwfjsffdjcqfmjgzqzvfsbhhvnwlfjfmdnphggdbnmpznlrzbnlbvhvplhjbzdmspnnlbctgzphghpngppdpdfbcdcpfntqlrwclsvnpljdbwcbhwzzdhbhsmslvvtjsmqmtpnhmmqnhfggnlpfthdhpwmrhzgfpwsffnrdqszcttrjsqzjqgspltfzzjnzwdfzvnmncwnphmjvcwlgrzcvpzcbndvhtjnfsgjtjdqfmgcgtgppsrcqwdjcqfddlhhnlfjrnsnssqblmnjjvmfbghtwwgcpgzfddvzsrsghqfrpvdtqmjfrzpvclmsnpmrqngdwvznlhdpbrzqtswfhnblnnbwjcwwbwfrgcdgrpphnslgnwbtfcgcmvvllwgvrcrdfcfwvwmdhhzmmnzmjgmgrgpdhngjgmhlqwtgzlngrbbfwfjrpwbqjnvdggrcfdgphfctvbmjnwfbpwrvbdbjrbhtnhfvhwvrptptsdrnzmnlwgbrwcswrccwdftgvjnvhffghdvhltjwhppfwfnmmtwclzzftzwvmhpmgvdsqzrfwqsmcgswnzjcnrvdgjlqdjrczphsvldlfzwdwmpncpvgqsvgpfpsfbgbmdhnfqbhdqwwwfdgqtmjlfbztsrwjrtqnrfpfqgplznpftrnjzhzcrnngqpwbrpbhlbfsgrpwfflrpbqdrqdplgcn'

; -- Previous statement must be properly terminated
WITH
  L0   AS(SELECT 1 AS c UNION ALL SELECT 1),
  L1   AS(SELECT 1 AS c FROM L0 CROSS JOIN L0 AS B),
  L2   AS(SELECT 1 AS c FROM L1 CROSS JOIN L1 AS B),
  L3   AS(SELECT 1 AS c FROM L2 CROSS JOIN L2 AS B),
  L4   AS(SELECT 1 AS c FROM L3 CROSS JOIN L3 AS B),
  L5   AS(SELECT 1 AS c FROM L4 CROSS JOIN L4 AS B),
  Nums AS(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n FROM L5)
, tally AS (SELECT TOP (LEN(@input)) n FROM Nums ORDER BY n)
, letterExplosion
AS
(
    SELECT 
	    SUBSTRING(REVERSE(@input), n, 1) AS letter
	    , REVERSE(SUBSTRING(REVERSE(@input), n, 4)) AS letter4 
        /* The REVERSEs are due to looking at previous 3 characters instead of the next 3). I could skip the reverses and just take the output +3 (group length - 1), but this is better for debugging */
        , LEN(@input) - n +1 AS position /* Position has to be reversed as well */
    FROM tally 
)
, groupOf4
AS
(
    SELECT 
	    *
        , SUBSTRING(REVERSE(le.letter4), multiplier.val, 1) AS groupLetter
    FROM letterExplosion AS le
    CROSS JOIN (VALUES (1), (2), (3), (4)) multiplier(val)
)
SELECT TOP (1)
	g4.position AS FirstPositionOf4
FROM groupOf4 AS g4
WHERE g4.position > 3
GROUP BY g4.position
HAVING COUNT(DISTINCT g4.groupLetter) = 4
ORDER BY g4.position

/*
###############################################################################
	Part 2
###############################################################################
*/

; -- Previous statement must be properly terminated
WITH
  L0   AS(SELECT 1 AS c UNION ALL SELECT 1),
  L1   AS(SELECT 1 AS c FROM L0 CROSS JOIN L0 AS B),
  L2   AS(SELECT 1 AS c FROM L1 CROSS JOIN L1 AS B),
  L3   AS(SELECT 1 AS c FROM L2 CROSS JOIN L2 AS B),
  L4   AS(SELECT 1 AS c FROM L3 CROSS JOIN L3 AS B),
  L5   AS(SELECT 1 AS c FROM L4 CROSS JOIN L4 AS B),
  Nums AS(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n FROM L5)
, tally AS (SELECT TOP (LEN(@input)) n FROM Nums ORDER BY n)
, letterExplosion
AS
(
    SELECT 
	    SUBSTRING(REVERSE(@input), n, 1) AS letter
	    , REVERSE(SUBSTRING(REVERSE(@input), n, 14)) AS letter14
        , LEN(@input) - n +1 AS position
    FROM tally 
)
, groupOf14
AS
(
    SELECT 
	    *
        , SUBSTRING(REVERSE(le.letter14), multiplier.val, 1) AS groupLetter
    FROM letterExplosion AS le
    CROSS JOIN (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (13), (14)) multiplier(val)
)
SELECT TOP (1)
	g14.position AS FirstPositionOf14
FROM groupOf14 AS g14
WHERE g14.position > 13
GROUP BY g14.position
HAVING COUNT(DISTINCT g14.groupLetter) = 14
ORDER BY g14.position

