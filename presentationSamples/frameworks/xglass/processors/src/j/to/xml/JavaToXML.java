package j.to.xml;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.LinkedHashMap;
import java.util.List;

import com.github.javaparser.JavaParser;
import com.github.javaparser.ParseException;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.body.MethodDeclaration;
import com.github.javaparser.ast.body.ModifierSet;
import com.github.javaparser.ast.body.Parameter;
import com.github.javaparser.ast.body.TypeDeclaration;
import com.github.javaparser.ast.comments.Comment;
import com.github.javaparser.ast.visitor.VoidVisitorAdapter;


public class JavaToXML {
	
	/**
	 * Convert Java to XML
	 * 
	 * @param is Input stream.
	 * @param os Output stream.
	 * @throws IOException
	 */
	public static void javaToXML(InputStream is, OutputStream os) throws IOException{
		try{
			final Writer wr = new OutputStreamWriter(os, "UTF8");
			
			CompilationUnit cu = JavaParser.parse(is);
			final TypeDeclaration clazz = cu.getTypes().get(0);
			wr.write("<javaClass name='" + clazz.getName() + "'>");
			Comment comment = clazz.getComment();
			if(comment != null){
				String content = comment.getContent();
				if(content != null){
					wr.write("\n<javadoc><![CDATA[");
					wr.write(content.replace("* ", ""));
					wr.write("]]></javadoc>");
				}
			}
			new VoidVisitorAdapter<MethodDeclaration>() {
				@Override
				public void visit(MethodDeclaration meth, MethodDeclaration arg1) {
					if(ModifierSet.isPublic(meth.getModifiers()) || ModifierSet.isPublic(clazz.getModifiers())){
						try {
							wr.write("\n<method name=\"" + meth.getName() + "\"");
							int mods = meth.getModifiers();
							//Access
							String access = "";
							if(ModifierSet.isPublic(mods)){
								access = "public";
							} else if(ModifierSet.isProtected(mods)){
								access = "protected";
							} else if(ModifierSet.isPrivate(mods)){
								access = "private";
							}
							wr.write(" access=\"" + access + "\"");
							
							//Static or not
							String staticStr = "false";
							if(ModifierSet.isStatic(mods)){
								staticStr = "true";
							}
							wr.write(" static=\"" + staticStr + "\"");
							
							//Abstract or not
							String abstractStr = "false";
							if(ModifierSet.isAbstract(mods)){
								abstractStr = "true";
							}
							wr.write(" abstract=\"" + abstractStr + "\"");
							
							wr.write(">");
							Comment comment = meth.getComment();
							if(comment != null){
								String content = comment.getContent();
								if(content != null){
									wr.write("\n<javadoc><![CDATA[");
									wr.write(content.replace("* ", ""));
									wr.write("]]></javadoc>");
								}
							}
							wr.write("\n<declaration>" + meth.getDeclarationAsString() + "</declaration>");
							wr.write("\n<returnType>" + meth.getType() + "</returnType>");

							if(ModifierSet.isStatic(mods)){
								wr.write("\n<static>");
								wr.write("true");
								wr.write("</static>");
							}

							//TODO qualifier
							List<Parameter> params = meth.getParameters();
							if(params != null && params.size() > 0){
								wr.write("\n<params>");
								for (int i = 0; i < params.size(); i++) {
									Parameter param = params.get(i);
									wr.write("\n <param>");
									wr.write("\n  <type>");
									wr.write(param.getType().toString());
									wr.write("</type>");
									wr.write("\n  <name>");
									wr.write(param.getId().toString());
									wr.write("</name>");
									wr.write("\n </param>");
								}
								wr.write("\n</params>");
							}
							wr.write("\n</method>");
						} catch (IOException e) {
							throw new RuntimeException(e);
						}
					}
					super.visit(meth, arg1);
				}
			}.visit(cu, null);
			wr.write("\n</javaClass>");
			wr.flush();
		} catch(Exception ex){
			throw new IOException(ex);
		}
	}
		
	/**
   * Convert.
   * 
   * @throws IOException
   *  
   * @see ro.sync.net.protocol.convert.ConversionProvider#convert(java.lang.String, java.lang.String, java.io.InputStream, java.io.OutputStream, java.util.LinkedHashMap)
   */
  public void convert(String systemID, String originalSourceSystemID, InputStream is, OutputStream os,
      LinkedHashMap<String, String> properties) throws IOException {
	  javaToXML(is, os);
  }
}
