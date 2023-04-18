# Stack-only benchmarks
Blocks not containing instructions that update memory or storage

## Benchmarks from GASOL

    * GASOL_gas_no_simp.txt   
      (36624 blocks, optimized wrt. gas, no simplification rules applied)
    * GASOL_gas_simp.txt      
      (43228 blocks, optimized wrt. gas, simplification rules applied)
    * GASOL_size_no_simp.txt  
      (35754 blocks, optimized wrt. size, no simplification rules applied)
    * GASOL_size_simp.txt     
      (32192 blocks, optimized wrt. size, simplification rules applied)

Blocks obtained from 96 real smart contracts in the Ethereum blockchain:

1. csv: 0x0621213b273bff05d679d9b1c68ec18cf989168f.sol.csv
1. csv: 0x0edc5ac3da3df2e4643aca1a777ca9eb6656117a.sol.csv
1. csv: 0x0f066b014adb057cdfc6c587965fbaa14151dfa5.sol.csv
1. csv: 0x100739d55a4e8361dcca7e872426c4b6aadeb201.sol.csv
1. csv: 0x16c19aaae850bb0282b38686fb071fe37edecf1f.sol.csv
1. csv: 0x16d1884381d94b372e6020a28bf41bbabe8c1f26.sol.csv
1. csv: 0x1c52b09ccddd1b6999400b038c7e0680eaf03dcd.sol.csv
1. csv: 0x1Ee8923Db533Ecb7A4650cCc8829D6F114D718f9.sol.csv
1. csv: 0x269028c988db0e6786de1f4ff66af7c033d0f6c8.sol.csv
1. csv: 0x2ccc239e97d01ad4c39a323327bc1a1f4cb43076.sol.csv
1. csv: 0x2e12AE85aF4121156F62ad4D059415C746fe615c.sol.csv
1. csv: 0x34662bf3ad9b3a70ea5b46ad81f4e9cab4d89a7f.sol.csv
1. csv: 0x359651fb6636cb650Fa47F11C9D35533BbFF8158.sol.csv
1. csv: 0x3948b7b6b8812439ddcbc8fa42cac8e213191792.sol.csv
1. csv: 0x3ae30bb991be0d54fddfedc7d6556e20daa97c71.sol.csv
1. csv: 0x3e456b66425f02bfe3896c1cc3b8513ff660b4bf.sol.csv
1. csv: 0x4152e8133d79279881013789100246a907884b9e.sol.csv
1. csv: 0x4226cac9567e991f956f644b656ce4aa0599c63e.sol.csv
1. csv: 0x44f8217a9dbb45ef2491da6aa18826bd6ded7847.sol.csv
1. csv: 0x450f184242894d068a71d3abfa296a73df1e192c.sol.csv
1. csv: 0x4757388aa7e3490106092bde16c23e2858c7d405.sol.csv
1. csv: 0x47B51F81E03fB068d776CcB78b08F59e5256B944.sol.csv
1. csv: 0x49173F2BF921Ce4124A8C6aBad3c5875Ff40D951.sol.csv
1. csv: 0x49566ab7ef0d4da06a3117e9e4fb3e9947abaf96.sol.csv
1. csv: 0x4d2d88d73ab4062d61b1eb68b5808b9176cef271.sol.csv
1. csv: 0x4d37D0aB328e1D449Ea8CFc3b0B7364B398c41E0.sol.csv
1. csv: 0x4E4bd1f64232450bEa37c4CB76D4b4cda3d46DAa.sol.csv
1. csv: 0x4f73c17195d0f77c1fc4175345b9251a9fb21849.sol.csv
1. csv: 0x4f89a0d9d868a39ec7024828dcaaae140a1a7ff3.sol.csv
1. csv: 0x5036f390F631f66284253864aE351B0297E32f03.sol.csv
1. csv: 0x50b6c438f108b5c0145142f54d538e704c55995b.sol.csv
1. csv: 0x54adf7604d25ac9476fc467e93dfdb29af1077ee.sol.csv
1. csv: 0x58760b75093a8462eb2eab2c5769ba5c0b18fa68.sol.csv
1. csv: 0x5d2fdd14e44b090f2eef03c715d414039f86d7bd.sol.csv
1. csv: 0x60e600a4d09297f9e9bb6eb90373f48e7830e69c.sol.csv
1. csv: 0x6365303A5E1C1327b36bDa8C22440be94eCCbcA1.sol.csv
1. csv: 0x64b88f10faf1603b70fb7370a00c43369f329515.sol.csv
1. csv: 0x697720ee431148a586a546551de6c4d575e4d8d0.sol.csv
1. csv: 0x6cd5a65e85c9603df74d4311d76145820556548a.sol.csv
1. csv: 0x6e53a6441b24cb773adcc6e6f9d43e956e7c9a6e.sol.csv
1. csv: 0x70001ba1ba4d85739e7b6a7c646b8aba5ed6c888.sol.csv
1. csv: 0x702197775Ab2B462Af51Ba11b38d103AaA0bb443.sol.csv
1. csv: 0x72BD2930663b30dBA3cd362bc1f8C2251E24C73A.sol.csv
1. csv: 0x766a339751Df1705364D961b4f7f87309F210355.sol.csv
1. csv: 0x7a741d7ff3da76d722fa4a37455f099efd0ef168.sol.csv
1. csv: 0x7bd251d43d8ee259acde7788ec93b7f3d6626dd2.sol.csv
1. csv: 0x7dDA9F944c3Daf27fbe3B8f27EC5f14FE3fa94BF.sol.csv
1. csv: 0x7F197F94cA6e57Fd983cE0fa29710cfA3b842bf8.sol.csv
1. csv: 0x89872650fa1a391f58b4e144222bb02e44db7e3b.sol.csv
1. csv: 0x8EfbD976709c2bD46bdaf0c3Db83E875F1451BAE.sol.csv
1. csv: 0x8f093895cd4c54eab897c6377e1bf85fe5b4e948.sol.csv
1. csv: 0x8f3b62dd6a9bf905516f433c214753934b337e05.sol.csv
1. csv: 0x90f24a2432a8b2e87b5a2026855181317890d129.sol.csv
1. csv: 0x949205a8e58bd1e5eb043c6379d1e7564a85039a.sol.csv
1. csv: 0x94a79038D97e22AC47C9Aa41624f948BDd7ac27D.sol.csv
1. csv: 0x99E2C293A8A6c3dAE6A591CEA322D0c3Cd231B2C.sol.csv
1. csv: 0xa403f555e419e56F49ba90022f7E7d0d3e86522D.sol.csv
1. csv: 0xa7b30042c7e798d0be8e466bf879388acddc526f.sol.csv
1. csv: 0xaa30979b30523bff7ca2ba434d126d15ad5b0905.sol.csv
1. csv: 0xAa7B19b68a1da16f272564e74b0e99f969c4DF6a.sol.csv
1. csv: 0xAbF18841Dca279a030bd9A9122F4460Da57ad547.sol.csv
1. csv: 0xAbf52Fc6e5C0e6E44Daac7C6ca79498302D9B0CA.sol.csv
1. csv: 0xb4e2ebaf639fd03aebe85bd0960b49ade9879b0f.sol.csv
1. csv: 0xb4feb1f99fc9e2688729fc899e1ee3631bbebded.sol.csv
1. csv: 0xb5615b9799427280cbc34a33233ef59b6409a711.sol.csv
1. csv: 0xb595e208833164d43a08ce529acc2b803d33c30e.sol.csv
1. csv: 0xb6105c0fa743290f94da9bf304ac45c19f4b2851.sol.csv
1. csv: 0xb8ec5b27de7d971d74e8531baa27853cffdfae1d.sol.csv
1. csv: 0xbb4ed94d1f743a8bba6318c821a7e9cf1d632c96.sol.csv
1. csv: 0xbdafddc47d1cbac27f80a918908922aa6bf4b5bc.sol.csv
1. csv: 0xbdf9d5752ec89a3b7c3b7ffe31f5bd565016c221.sol.csv
1. csv: 0xc581bced4dedab50e8bfdcc67b2a36b92e013d78.sol.csv
1. csv: 0xcbdbc7c264c1abff6646bdd5ba13f1664823b0cd.sol.csv
1. csv: 0xcc07e50a953c8c61f5dc077ed171e46210e9783e.sol.csv
1. csv: 0xcCFFC73347B05cBDCCe7c3de2a0AdEcDAa8AEf51.sol.csv
1. csv: 0xcD097cdB473286a10Cf19CbA9597E4400e8B6943.sol.csv
1. csv: 0xcfc131c7810f9f7ec859bd3dd020bdb4bb06a5a8.sol.csv
1. csv: 0xd2947e1e2ea5c4cd14aaa2b7492549129b087daa.sol.csv
1. csv: 0xda44b167ca409b7fc51ccbd6ef3338b8e19999a8.sol.csv
1. csv: 0xde1972989f633f10b6e6dc581b785c4618aa8490.sol.csv
1. csv: 0xdfd5235a6d3e184ba27307d7d21ae9b425ff4e6d.sol.csv
1. csv: 0xe45D283123607B7D97856d49C965faa40542BA94.sol.csv
1. csv: 0xe7a2241e92c7b7299452e63d53af6692dfcd0367.sol.csv
1. csv: 0xe8d2f4b9edbb0244167339c3a8daa6d82d959e72.sol.csv
1. csv: 0xEadC2a6fff036C12e62A74392d4c6CA77A5Ea007.sol.csv
1. csv: 0xeb453a070c20e79ff148e0506bd02c30b577af43.sol.csv
1. csv: 0xEf78B55bD7bC090F809535f3B32Bcf1E050815df.sol.csv
1. csv: 0xF0B0ccED14b2d1D47C351F5Bc0B33AA79470997e.sol.csv
1. csv: 0xf1cb8f9738adff8c280d6eae8e2285a839b79f80.sol.csv
1. csv: 0xF2281cA8693B1d35D7a73700909ec8535A57156D.sol.csv
1. csv: 0xf508bda527d4ef9db712eb0100f1cd8f573bbe88.sol.csv
1. csv: 0xf66ff968773e45dad3e1ac13ffbb63fae0eb1624.sol.csv
1. csv: 0xf7a84edAc5539b75AFaaA04f1103dBf9Db4b09c6.sol.csv
1. csv: 0xfa1c9bf3de714059b3c019facdcaef785cab098e.sol.csv
1. csv: 0xfc21969625ae8933e85b49df3cc28aa7092fcfc7.sol.csv
1. csv: 0xfeff9661617cbba5a2ed3a69000f4bf1e266be71.sol.csv    

## Benchmarks from `solc`

    * solc_semantic_tests.txt  (1280 blocks)

Blocks obtained from the semantic test suite of the `solc` compiler (https://github.com/ethereum/solidity/tree/develop/test/libsolidity/semanticTests/externalContracts.)    