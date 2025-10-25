#################################################
#  ISTIC - TP5-6 - L3 Info ILM SE - 2023/2024 	#
#						#
#  	BOUCHER - Josselin - josselin.boucher@etudiant.univ-rennes.fr #
#  	ANDRE LE POGAMP - Eliaz - eliaz.andrelepogamp@etudiant.univ-rennes.fr 		#
#						#
#################################################

# ce programme en assembleur est le template pour le TP5-6.(mais complet pour prof !!)

# constantes pour appel systÃ¨me
.eqv	PRINT_INT, 1
.eqv	PRINT_STRING, 4
.eqv	READ_INT, 5
.eqv    EXIT2, 93

.eqv	N,16      # taille tableau 
	.data
tableau:
	.word	4,38,10,23,11,72,31,45,7,13,23,17,2,5,9,87
	newline:
    .string "\n"
	.text
	j main     
	


	
# void triPaire(int *tab, int i, int j) {
# 	 int tmp;

#	|---------------|
#	|      tmp      | <--- sp
#	|---------------|
#	|    ra        | <--- sp + 4
#	|---------------|
 # TODO schÃ©ma de pile Ã  complÃ©ter

#

triPaire:
    addi sp,sp,-8        #alloue la mémoire pour la pile (8 octets, ra et tmp)
    sw a4, 0(sp)        #on sauvegarde a4 (tmp) à l'adresse sp
    sw ra, 4(sp)        #on sauvegarde ra pour revenir à l'appelant à l'adresse sp + 4
    
        slli t0, a1, 2      #on décale la valeur binaire de i (stockée dans a1) de deux bits vers la gauche, ce qui la multiplie par 4. C'est dû au format des entiers, codés sur 4 octets.    Cette instruction permet de stocker la valeur i * 4 dans t0.
        
        add  t0, a0, t0     #on additionne la valeur de t0 et celle de l'adresse du tableau pour atteindre tab[i], qu'on stocke dans t0 (en écrasant l'ancienne)
        
        lw   a3, 0(t0)      #on stocke tab[i] dans a3
    
        slli t1, a2, 2      #même logique mais avec j qui est stocké dans a2 et non a1 (on pourrait la mettre dans t0 pour être plus économes en registres mais c'était plus clair en les séparant)
        add  t1, a0, t1     #on stocke tab[j] dans t1
        lw   a4, 0(t1)      #on stocke tab[j] dans a4
    
    bge a4, a3, fin_if     #si tab[j] >= tab[i] on va à fin_if (cas où on swap pas)
    
    #cas où on swap (optimisable ?)
    sw  a4, 0(sp)   # tmp = tab[j]
    sw  a3, 0(t1)   # tab[j] = tab[i]
    lw  a5, 0(sp)   # a5 = tmp
    sw  a5, 0(t0)   # tab[i] = tmp
    
fin_if:            #on arrive directement ici si on a pas swap
    lw ra, 4(sp)    #ra reprend sa valeur initiale depuis la pile
    addi sp,sp,8     #supprime la mémoire allouée à la pile (sp revient à sa valeur d'avant l'appel à triPaire)
    
    ret        #retour à l'appelant

# Ne pas modifier cette procÃ©dure !!!
#
# void triBulle(int *tab, int taille) {
# 	 int i, j;

#	|---------------|
#	|  copie a1      | <--- sp
#	|---------------|
#	|  copie a0       | <--- sp + 4
#	|--------------|
#	|      i         | <--- sp + 8
#	|--------------|
#	|      j         | <--- sp + 12
#	|--------------|
#	|   copie ra     | <--- sp + 16
#       |---------------|
.eqv tb_d_a1,0		# sauvegarde a0 et a1 en tant qu'appelant
.eqv tb_d_a0,4		#   faites ici pour ne faire qu'une sauvegarde et non une Ã  chaque appel
.eqv tb_d_i,8		# var. loc i & j
.eqv tb_d_j,12
.eqv tb_d_ra,16


triBulle:
		addi 	sp,sp,-20  
		sw	ra,tb_d_ra(sp)
		sw	a1,tb_d_a1(sp)
		sw	a0,tb_d_a0(sp)
# 				 		for (i = 0; i < taille; i++)
		sw	zero,tb_d_i(sp)
# 						    
		j	test_for_i
loop_for_i:
# 					 		for (j = i; j < taille; j++) {
		lw	a5,tb_d_i(sp)
		sw	a5,tb_d_j(sp)
#
		j	test_for_j
#					  : 		
loop_for_j:
#					 			triPaire (tab,i,j)
		lw	a0,tb_d_a0(sp)
		lw	a1,tb_d_i(sp)
		lw	a2,tb_d_j(sp)
		call 	triPaire
# 					 		j++ (for)
		lw	a5,tb_d_j(sp)
		addi	a5,a5,1
		sw	a5,tb_d_j(sp)
test_for_j:
#				 			j < taille (for)
		lw	a4,tb_d_j(sp)
		lw	a5,tb_d_a1(sp)
		bltu 	a4,a5,loop_for_j  
#							}
#						i++ (for)
		lw	a5,tb_d_i(sp)
		addi 	a5,a5,1
		sw	a5,tb_d_i(sp)
test_for_i:
# 						i < taille (for)
		lw	a4,tb_d_i(sp)
		lw	a5,tb_d_a1(sp)
		bltu	a4,a5,loop_for_i
# 						}
		lw	ra,tb_d_ra(sp)
		addi	sp,sp,20
		ret

# int rechercheDicho(int val, int *tab, int debut, int fin) {
#		int pos;
#        int pos;
#    |---------------|
#    |   s2          | <--- sp
#    |---------------|
#    |      s1       | <--- sp + 4
#    |---------------|
#    |  s0           | <--- sp + 8
#    |---------------|
#    |       ra      | <--- sp + 12
#    |---------------|
#    |               |


rechercheDicho:
    addi sp, sp, -16   # Alloue de l'espace sur la pile


    # Sauvegarde des registres dans la pile
    sw ra, 12(sp)       # Sauvegarde de l'adresse de retour
    sw s0, 8(sp)        # Sauvegarde de s0
    sw s1, 4(sp)        # Sauvegarde de s1
    sw s2, 0(sp)        # Sauvegarde de s2


    # Cas de base : si debut > fin
    blt  a3, a2, non_present

    # Calcul de position 
    sub s0, a3, a2    #s0 <- (fin-debut)
    srli s0, s0, 1    #s0 <- s0/2
    add s0, s0, a2    #s0 <- s0+debut

    # Chargement de la valeur à l'indice position dans t1
    slli s1, s0, 2      #récuperation de la place d'une case en octet pour le tableau
    add s1, a1, s1    #obtention de l'indice dans 
    lw s2, 0(s1)    #affectation dans t0 de tab[position]

    # comparaison entre tab[position] et valeur
    beq s2, a0, present	    #si valeur = tab[position]
    blt s2, a0, present_droit  	#valeur < tab[position]
    bge s2, a0, present_gauche	#valeur > tab [position]

present_gauche:
    addi a3, s0, -1	#on effectue l'operation fin = pos -1
    jal rechercheDicho	#appel recursif 
    j liberation_pile	#après appel recursif liberation de la pile


present_droit:
    addi a2, s0, 1	#on effectue l'operation debut = pos +1
    jal rechercheDicho   #appel recursif
    j liberation_pile	#après appel recursif liberation de la pile

non_present:
    li a0, -1
    j liberation_pile

present:
    mv a0, s0
    j liberation_pile
    
liberation_pile:
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    ret

#
#
#  Ne pas modifier tout ce qui suit !!!
#
# void print_array(int *tab, int taille) {
# 	 int k;

#	|---------------|
#	|  copie a0      | <--- sp
#	|---------------|
#	|  sauv s1       | <--- sp + 4
#	|---------------|
#	|  sauv s0       | <--- sp + 8
#	|---------------|
#	|     k          | <--- sp + 12
#	|---------------|
#	|   copie ra     | <--- sp + 16
#       |---------------|
.eqv	pa_d_ra,,16
.eqv	pa_d_k,,12
.eqv	pa_d_s0,8
.eqv	pa_d_s1,4
.eqv	pa_d_a0,0	# sauvegarde a0 appelant (une seule sauvegarde au lieu d'une par appel)

print_array:
	addi	sp,sp,-20	#,,
	sw	ra,pa_d_ra(sp)	#,
	sw	s0,pa_d_s0(sp)	#,
	sw	s1,pa_d_s1(sp)	# 
	sw	a0,pa_d_a0(sp) #

.LBB2:
# 					for (unsigned int k = 0; k < N; k++) {
	sw	zero,pa_d_k(sp)	#, k=0
# 					  
	j	.L15		#
.L16:
# 						print_int(tab[k]);
	lw	s0,pa_d_k(sp)		
	slli	s0,s0,2	
	lw	s1,pa_d_a0(sp)		
	add	s0,s0,s1	#		s0 = @ tab[k]
	lw	a0,0(s0)		
	li	a7,PRINT_INT
	ecall			
# 						print_string(" ");
	la	a0,.LC0
	li 	a7,PRINT_STRING
	ecall	
#				   	   k++ (for )
	lw	s0,pa_d_k(sp)		
	addi	s0,s0,1	
	sw	s0,pa_d_k(sp)	
.L15:
# 					   k < N (for)
	lw	s0,pa_d_k(sp)		
	bltu	s0,a1,.L16
#					}	
.LBE2:
# 					print_string("\n");
	la	a0,.LC1
	li	a7,PRINT_STRING,
	ecall			#
# 
	lw	ra,pa_d_ra(sp)		
	lw	s0,pa_d_s0(sp)		
	addi	sp,sp,20	#,,
	ret	#
	
#
#	int main
#		int v,pos
#	|---------------|
#	|  pos            | <--- sp
#	|---------------|
#	|  v             | <--- sp + 4
#	|---------------|

	.data
.LC0:
	.string	" "
.LC1:
	.string	"\n"
.LC2:
	.string	"Tableau non triÃ©\n"
.LC3:
	.string	"Tableau triÃ©\n"

.LC4:
	.string	"Entrez la valeur Ã  chercher : "

.LC5:
	.string	"Valeur trouvÃ©e Ã  la position : "
.eqv	m_d_v, 4
.eqv	m_d_pos, 0	
	
	.text

main:
	addi	sp,sp,-8	#,,

#: 					print_string("Tableau non triÃ© \n");
	la	a0,.LC2	
	li	a7,PRINT_STRING	
	ecall	
#					print_array(tableau, N);;
	li	a1,N		#,
	la	a0,tableau
	call	print_array		#
# 					print_string("Tableau triÃ©\n");
	la	a0,.LC3
	li	a7,PRINT_STRING
	ecall	
# 					triBulle(tableau, N);
	li	a1,N		
	la	a0,tableau	
	call	triBulle		#
#: 					print_array(tableau, N);;
	li	a1,N	
	la	a0,tableau
	call	print_array		#
#					print_string("\n");
	la	a0,.LC1	
	li	a7,PRINT_STRING
	ecall	
	
	
# 			 	while(true) {;
_while:	

# 					print_string("Entrez la valeur Ã  chercher \n");
	la 	a0, .LC4
	li 	a7,PRINT_STRING		#,
	ecall	

# t					v= read_int();
	li 	a7,READ_INT		#,
	ecall	
	sw	a0,m_d_v(sp)

# 					if (v<0) break;
	blt 	a0,zero, _end_while
	
# 					pos = rechercheDicho(v, tableau, 0, N - 1);
	li	a3,N			#,
	addi	a3,a3,-1
	li	a2,0			#,
	la	a1,tableau		#, 
	lw	a0,m_d_v(sp)

	call	rechercheDicho		#
	sw	a0, m_d_pos(sp)		# _1,

#					print_string("Valeur trouvÃ©e Ã  la position \n");
	la 	a0, .LC5
	li 	a7,PRINT_STRING		#,
	ecall	

#					print_int(pos);
	lw	a0, m_d_pos(sp)
	li	a7,PRINT_INT		#,
	ecall	

#					print_string("\n");
	la	a0,.LC1	
	li	a7,PRINT_STRING
	ecall	

#  				}
	b _while

_end_while:

	addi	sp,sp,8
	li	a0, 0
	li	a7, EXIT2
	ecall
	ebreak
	
