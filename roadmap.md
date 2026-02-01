# **🗺️ MAP COMPLÈTE pour Réaliser Push_swap**

Voici un **plan détaillé étape par étape** pour réussir ce projet :

```
┌─────────────────────────────────────────────────────────────┐
│                     PUSH_SWAP ROADMAP                        │
└─────────────────────────────────────────────────────────────┘
```

---

## **🏁 PHASE 0 : PRÉPARATION (Jour 1)**

### **📁 Structure des Fichiers**
```
push_swap/
├── Makefile
├── includes/
│   └── push_swap.h
├── srcs/
│   ├── main.c
│   ├── parsing/
│   │   ├── parse_args.c
│   │   └── validate_args.c
│   ├── utils/
│   │   ├── utils.c
│   │   └── utils2.c
│   ├── operations/
│   │   ├── push.c
│   │   ├── swap.c
│   │   ├── rotate.c
│   │   └── reverse_rotate.c
│   ├── stack/
│   │   ├── stack_utils.c
│   │   └── stack_init.c
│   ├── sorting/
│   │   ├── small_sort.c      (2-5 éléments)
│   │   ├── medium_sort.c     (6-100 éléments)
│   │   └── big_sort.c        (101+ éléments)
│   └── algorithm/
│       ├── normalize.c
│       ├── radix_sort.c
│       └── chunk_sort.c
└── libft/                    (si tu utilises ta libft)
```

---

## **🔧 PHASE 1 : LES BASES (Jours 2-3)**

### **Étape 1.1 : La Structure de Données**
```c
// push_swap.h
typedef struct s_node
{
    int             value;   
    int             index;
    struct s_node   *next;

} t_node;


```

### **Étape 1.2 : Les Fonctions de Base de Stack**
- `stack_new()` - créer une nouvelle pile
- `stack_add_back()` - ajouter à la fin
- `stack_add_front()` - ajouter au début
- `stack_last()` - dernier élément
- `stack_size()` - taille de la pile
- `stack_free()` - libérer la mémoire

---

## **⚙️ PHASE 2 : PARSING (Jours 3-4)**

### **Étape 2.1 : Validation des Arguments**
```c
// Cas à gérer :
// 1. "./push_swap 1 2 3"          → OK
// 2. "./push_swap "1 2 3""        → OK (une string)
// 3. "./push_swap "1" "2" "3""    → OK
// 4. "./push_swap 1 2 two"        → Error
// 5. "./push_swap 1 2 1"          → Error (duplicate)
// 6. "./push_swap 1 9999999999"   → Error (overflow)
```

### **Étape 2.2 : Fonctions de Parsing**
1. `parse_args()` - traiter argv
2. `check_duplicates()` - vérifier les doublons
3. `check_int_overflow()` - vérifier les limites
4. `ft_atoi_modified()` - atoi avec gestion d'erreur

---

## **🔄 PHASE 3 : OPÉRATIONS (Jours 4-5)**

### **Étape 3.1 : Implémenter les 11 Opérations**
**Groupe 1 - Push :**
- `pa()` - de b vers a
- `pb()` - de a vers b

**Groupe 2 - Swap :**
- `sa()` - swap a
- `sb()` - swap b  
- `ss()` - sa + sb

**Groupe 3 - Rotate :**
- `ra()` - rotate a
- `rb()` - rotate b
- `rr()` - ra + rb

**Groupe 4 - Reverse Rotate :**
- `rra()` - reverse rotate a
- `rrb()` - reverse rotate b
- `rrr()` - rra + rrb

### **Étape 3.2 : Tester Chaque Opération**
Crée un **main de test** :
```c
// test_operations.c
int main(void)
{
    t_stack *a = create_stack_a("1 2 3 4");
    print_stack(a);
    
    sa(a);  // Test swap
    print_stack(a);  // Devrait afficher [2, 1, 3, 4]
    
    free_stack(a);
    return 0;
}
```

---

## **📊 PHASE 4 : TRI POUR PETITES LISTES (Jours 5-6)**

### **Étape 4.1 : Cas 2 et 3 Éléments**
```c
// Cas 2 éléments : [2, 1] → sa → [1, 2]
// Cas 3 éléments : algorithmes fixes
void    sort_three(t_stack *a)
{
    // 6 combinaisons possibles :
    // [1,2,3] → déjà trié
    // [1,3,2] → sa, rra
    // [2,1,3] → sa
    // [2,3,1] → rra
    // [3,1,2] → ra
    // [3,2,1] → sa, rra
}
```

### **Étape 4.2 : Cas 4 et 5 Éléments**
Algorithme :
1. Trouver le plus petit
2. Le mettre en haut avec `ra`/`rra`
3. `pb` vers b
4. Répéter jusqu'à avoir 3 éléments dans a
5. `sort_three(a)`
6. `pa` les éléments de b

---

## **🎯 PHASE 5 : NORMALISATION (Jour 6)**

### **Étape 5.1 : Implémentation**
```c
void normalize_stack(t_stack *stack)
{
    // 1. Créer un tableau des valeurs
    int *arr = stack_to_array(stack);
    
    // 2. Trier le tableau (avec qsort)
    int *sorted = sort_array(arr, stack->size);
    
    // 3. Assigner les indices
    for (chaque node dans stack)
    {
        node->index = find_index(node->value, sorted);
        // OU : node->value = find_index(...) si tu remplaces
    }
}
```

### **Étape 5.2 : Choix Stratégique**
**Option A (recommandée) :** Remplacer `value` par l'index  
**Option B :** Garder `value` et ajouter champ `index`

---

## **🚀 PHASE 6 : RADIX SORT (Jours 7-8)**

### **Étape 6.1 : Implémentation de Base**
```c
void radix_sort(t_stack *a, t_stack *b)
{
    int max_bits = calculate_max_bits(a->size);
    int size = a->size;
    
    for (int bit = 0; bit < max_bits; bit++)
    {
        for (int i = 0; i < size; i++)
        {
            int num = a->top->index;  // ou a->top->value si normalisé
            
            if ((num >> bit) & 1)     // Si le bit est 1
                ra(a);
            else                      // Si le bit est 0
                pb(a, b);
        }
        
        // Remettre tout dans a
        while (b->size > 0)
            pa(a, b);
    }
}
```

### **Étape 6.2 : Optimisations**
1. **Calculer max_bits** : `log2(max_index) + 1`
2. **Gestion du nombre d'éléments** à chaque passe
3. **Variante** : si bit=0 → pb, bit=1 → ra

---

## **⚡ PHASE 7 : ALTERNATIVE - CHUNK SORT (Optionnel, Jours 9-10)**

### **Pour améliorer les performances :**
```c
void chunk_sort(t_stack *a, t_stack *b, int chunk_size)
{
    // Phase 1 : Push vers b par chunks
    while (a->size > 0)
    {
        find_best_in_chunk(a, chunk_size);
        push_to_b(a, b);
    }
    
    // Phase 2 : Remettre dans a en ordre
    while (b->size > 0)
    {
        find_max_in_b(b);
        push_to_a(a, b);
    }
}
```

---

## **🧪 PHASE 8 : TESTS ET OPTIMISATION (Jours 10-12)**

### **Étape 8.1 : Tests Automatiques**
```bash
# Script de test
for i in {1..100}
do
    # Génère nombres aléatoires
    ARG=$(ruby -e "puts (1..100).to_a.shuffle.join(' ')")
    
    # Compte les opérations
    OPERATIONS=$(./push_swap $ARG | wc -l)
    
    # Vérifie le tri
    ./push_swap $ARG | ./checker $ARG
    
    echo "Test $i: $OPERATIONS ops"
done
```

### **Étape 8.2 : Benchmarks**
```
Objectifs à atteindre :
✅ 3 nombres  : ≤ 3 ops
✅ 5 nombres  : ≤ 12 ops
✅ 100 nombres: < 700 ops  (pour 100%)
✅ 500 nombres: < 5500 ops (pour 100%)
```

### **Étape 8.3 : Optimisations**
1. **Combiner opérations** : `rr` au lieu de `ra`+`rb`
2. **Éviter les opérations inutiles**
3. **Choix d'algorithme adapté** :
   - n ≤ 5 : tri manuel
   - 6 ≤ n ≤ 100 : insertion sort amélioré
   - n ≥ 100 : radix sort

---

## **🏆 PHASE 9 : BONUS - CHECKER (Jours 12-14)**

### **Étape 9.1 : Parser les Instructions**
```c
void read_instructions(t_stack *a, t_stack *b)
{
    char *line;
    
    while (1)
    {
        line = get_next_line(0);  // ou read()
        if (!line)
            break;
            
        execute_instruction(line, a, b);
        free(line);
    }
}
```

### **Étape 9.2 : Vérification Finale**
```c
int is_sorted(t_stack *a)
{
    t_node *current = a->top;
    
    while (current && current->next)
    {
        if (current->value > current->next->value)
            return (0);
        current = current->next;
    }
    return (1);
}
```

---

## **📝 PHASE 10 : FINALISATION (Jour 15)**

### **Étape 10.1 : Makefile**
```makefile
NAME = push_swap
BONUS = checker

CC = cc
CFLAGS = -Wall -Wextra -Werror

SRCS = $(wildcard srcs/*.c) $(wildcard srcs/*/*.c)
OBJS = $(SRCS:.c=.o)

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) -o $(NAME) $(OBJS)

bonus: $(BONUS)

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME) $(BONUS)

re: fclean all
```

### **Étape 10.2 : Norminette et leaks**
```bash
# Vérifier la norme
norminette

# Vérifier les leaks
valgrind --leak-check=full ./push_swap 4 67 3 87 23
```

---

## **🎯 PLAN RÉCAPITULATIF JOURNALIER**

| Jour | Objectif | Durée estimée |
|------|----------|---------------|
| 1 | Structure, Makefile, headers | 4h |
| 2 | Structures de piles, fonctions de base | 6h |
| 3 | Parsing et validation | 6h |
| 4 | Implémenter les 11 opérations | 6h |
| 5 | Tri pour 2-5 éléments | 5h |
| 6 | Normalisation | 4h |
| 7 | Radix Sort de base | 6h |
| 8 | Radix Sort optimisé | 6h |
| 9 | Tests et benchmarks | 5h |
| 10 | Optimisations finales | 4h |
| 11-12 | Bonus checker | 10h |
| 13 | Tests complets | 4h |
| 14 | Makefile, norme, leaks | 4h |
| 15 | Buffer pour imprévus | 6h |

**Total : ~15 jours à raison de 4-6h/jour**

---

## **🆘 CONSEILS DE SURVIE**

### **Priorités :**
1. **D'abord faire marcher**, ensuite optimiser
2. **Tester après chaque fonction**
3. **Versionner avec Git** (`git commit -m "étape X"`)
4. **Faire des pauses** quand tu bloques

### **Outils utiles :**
- **Visualiseur** : https://github.com/o-reo/push_swap_visualizer
- **Testeur** : https://github.com/laisarena/push_swap_tester
- **Générateur** : `ruby -e "puts (1..100).to_a.shuffle.join(' ')"`

### **Points de Blocage Fréquents :**
1. **Parsing** : bien gérer les quotes et strings
2. **Doublons** : utiliser un tableau de vérification
3. **Radix** : bien comprendre la normalisation
4. **Leaks** : tout malloc doit avoir son free

---

## **🚦 CHECKLIST FINALE**
- [ ] Parsing valide tous les cas
- [ ] 11 opérations implémentées
- [ ] Tri 2-5 éléments fonctionne
- [ ] Normalisation correcte
- [ ] Radix Sort fonctionne
- [ ] Benchmarks atteints
- [ ] Makefile avec règles
- [ ] Pas de leaks
- [ ] Norminette OK
- [ ] Bonus checker (optionnel)

**BON COURAGE !** 🚀  
Le projet est exigeant mais **très formateur**.  
Chaque étape te prépare pour la suivante.