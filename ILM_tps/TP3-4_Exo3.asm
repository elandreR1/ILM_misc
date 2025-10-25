####################################
#    - ISTIC - L3 Info - ILM -     #
####################################

# ce programme en assembleur est le template pour le TP3-4.

.globl main

.eqv	PRINT_INT, 1
.eqv	PRINT_STRING, 4
.eqv	READ_INT, 5
.eqv    EXIT2, 93

.data
a:		.word 0
b:		.word 0
resultat:	.word 0

invite_a:	.asciz "Entrez un entier (a): "
invite_b:	.asciz "Entrez un entier (b): "
msg_res:	.asciz "Le PGCD de a et b est: "



.text
main:
	
	#Affichage invite_a
	la	a0, invite_a
	li	a7, PRINT_STRING
	ecall
	
	#Demande a Ã  l'utilisateur
	li	a7, READ_INT
	ecall
	la  a1, a
	sw	a0, 0(a1)
	
	#Affichage invite_b
	la	a0, invite_b
	li	a7, PRINT_STRING
	ecall
	
	#Demande b Ã  l'utilisateur
	li a7, READ_INT
	ecall

	la a1,b 
	sw a0,(a1)
	

    # chargement des valeurs de a et b dans les registres d'arguments
    la a4, a
    lw a0, 0(a4)  # chargement de a dans a0

    la a5, b
    lw a1, 0(a5)  # chargement de b dans a1

    # appel la fonction pgcd
    jal pgcd

    # stockage du résultat dans la mémoire
    la a5, resultat
    sw a0, 0(a5)
    
resultaAFF:
	#Affichage msg_res
	la	a0, msg_res
	li	a7, PRINT_STRING
	ecall
	
	#Affichage resultat
	la	a0, resultat
	lw	a0, 0(a0)
	li	a7, 1
	ecall
	
		# Calcul du PGCD avec fonction - Exercice 3

# Calcul du PGCD avec fonction - Exercice 3
	# ...
	# (Votre code ici)
	# ...
	
	#exit
	li	a0, 0
	li	a7, EXIT2
	ecall
	ebreak

pgcd:
    addi sp, sp, -8	#allocation de 8 octet sur la pile
    sw   ra, 4(sp)	#sauvegarde de ra l'adresse retour

pgcd_loop:
    beq a0, a1, pgcd_end  # Si a == b, on retourne la valeur

    bgt a0, a1, sub_a      # Si a > b, on soustrait b de a
    sub a1, a1, a0         # Sinon, b = b - a
    j pgcd_loop

sub_a:
    sub a0, a0, a1         # a = a - b
    j pgcd_loop

pgcd_end:
    lw   ra, 4(sp)	#restaure l'adresse de retour avec le sp (stack pointer)
    addi sp, sp, 8	#libere l'espace sur la pile

    ret  # retourne la valeur PGCD dans a0
