struct cslabel {
        char *t;
        char *f;
};
typedef struct cslabel label;

label * gen_label() {
	label *ptr;
	ptr = (label *) malloc(sizeof(label));
	return ptr;
}
	


